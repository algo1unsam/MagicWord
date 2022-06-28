/** First Wollok example */
import wollok.game.*
import objetos.*
import objects.*
import quest.*
import maps.*
import Opciones.*
object juego {
	const fabrica = new FactorySoil(type=0)
	const fabricaitem = new FactoryItem(type=0)
	var property puntos 
	var listcolisiones = []
	var property objetos=[]
	var textura = []
	var property idioma = opcionlenguaje.espanol()
	const pixel = 2
	const celdas = 480 / pixel
	method preconfig(){
		game.width(celdas)
		game.height(celdas)
		game.cellSize(pixel)
		game.title("RPG idiomas")
		
	}
	method liberar(){
		textura.clear()
		objetos.clear()
		game.clear()
	}
	method iniciar(){
		
		itemdic.load()
		menudic.load()
		listquest.load()
		self.menu()
		self.preconfig()
		game.start()
	}	
	method menu(){
		self.cambiarEscenario(-1)					
		var titulos=[]
		titulos.add(new Objeto(x=0*16,y=10*16,image=menudic.list().get("titulo")))
		titulos.add(new Objeto(x=4*16,y=9*16,image=menudic.list().get("inicio")))
		titulos.add(new Objeto(x=4*16,y=6*16,image=menudic.list().get("idioma")))
		titulos.add(new Objeto(x=4*16,y=3*16,image=menudic.list().get("salir")))
		titulos.forEach({p => game.addVisual(p)})	
		var tidioma = new Objeto(x=8*16,y=6*16,image=menudic.list().get(opcionlenguaje.toString(idioma)))
		game.addVisual(tidioma)
		game.addVisual(puntero)
		teclado.setConfig(opcionteclado.menu())
	}
	method submenu(){
//		var auxtextura=textura
		self.cambiarEscenario(-1)
		var titulos=[]
		titulos.add(new Objeto(x=0*16,y=11*16,image=menudic.list().get("titulo2")))
		titulos.add(new Objeto(x=4*16,y=8*16,image=menudic.list().get("reiniciar")))
		titulos.add(new Objeto(x=4*16,y=4*16,image=menudic.list().get("salir")))
		titulos.forEach({p => game.addVisual(p)})
		teclado.setConfig(opcionteclado.submenu())	
	}
	method juego(){
		puntos=new Puntuacion()
		self.cambiarEscenario(0)
		//game.addVisual(personaje)
		//game.addVisual(maestro)
        //listcolisiones.add(maestro)
		
		/*objetos=[]
		 
		objetos.add(fabricaitem.make(3,11, '31')) 
		objetos.add(fabricaitem.make(5,11, '25')) 
		objetos.add(fabricaitem.make(7,11, '26')) 
		objetos.add(fabricaitem.make(9,11, '31')) 
		
		objetos.forEach({o=>game.addVisual(o) listcolisiones.add(o)})*/
		maestro.changeQuest()
		
		//teclado.setConfig("juego")
	}
	method removerObjetos(){
		objetos.forEach({o=>game.removeVisual(o) listcolisiones.remove(o)})
		objetos.clear()
	}
	
	method end(){
		self.liberar()
		if(puntos.acierto()>=20){
			self.cambiarEscenario(-3)
			game.addVisual(new Anuncios(x=2,y=10,text="juego perfecto",textColor="00FF00FF"))
		}		
		else if(puntos.acierto()>puntos.fracaso()){
			self.cambiarEscenario(-4)
			game.addVisual(new Anuncios(x=2,y=10,text="ganaste",textColor="00FF00FF"))
		}
		else{
			self.cambiarEscenario(-3)
			game.addVisual(new Anuncios(x=2,y=10,text="fallaste",textColor="FF0000FF"))
		}
		keyboard.any().onPressDo({
			self.liberar()
			self.menu()
		})
	}
	
	method cambiarEscenario(escenario){
		self.liberar()
		if(escenario<=0) textura=fabrica.makeMap(mapa1.vector())
		if(escenario==1) textura=fabrica.makeMap(mapa2.vector())
		if(escenario==-3) textura=fabrica.makeMap(mapa3.vector())
		if(escenario==-4) textura=fabrica.makeMap(mapa4.vector())
		textura.forEach({p=>game.addVisual(p)})
		if(escenario>=0){
			game.addVisual(personaje)
		    game.addVisual(maestro)
			if(!listcolisiones.contains(maestro)) listcolisiones.add(maestro)
			teclado.setConfig(opcionteclado.juego())
		}
		return null
	}
	
	method agregarObjetos(objs){
		objetos=fabricaitem.makes(objs)
		objetos.forEach({o=>game.addVisual(o) listcolisiones.add(o)})
	}
	//Nuevo sistema de colisiones, la dist son la diferencia de distancia
	//en objetos en este caso personaje e items pero funcionaria entre 
	// 2 personajes,enemigos,etc
	method isColision(obj1,obj2,dist_X,dist_Y){
		if ( obj1.x()+dist_X > obj2.x()+16 ) return false
		if ( obj1.x()+16+dist_X < obj2.x() ) return false
		if ( obj1.y()+dist_Y > obj2.y()+16 ) return false
		return !( obj1.y()+21+dist_Y < obj2.y() ) 
	}
	
	//Devuelve verdadero si el objeto a comparar colisiono con otro
	//en este caso se usa para ver si el personaje colisiona con un item
	method isColisiones(obj1,a,b){
		return !listcolisiones.all{obj=>!self.isColision(obj1,obj,a,b)}
	}
	//Devuelve el objeto que colisiono con el personaje 
	method colisiones(obj1,a,b){
		return listcolisiones.filter{obj=>self.isColision(obj1,obj,a,b)}
	}
}
object maestro{
	var property x=16*12
	var property y=16*12
	var property image ="personaje/maestro.png"
	var property quest
	var a=-1
	var mensaje=["Bienvenido nuevo alumno","Quieres probar tus conocimientos"]	
	method position() = game.at(x,y) 
	method texto(){
		a++
		if (a<2) return mensaje.get(a)
		return ""
	}
	method indicar(){return "Encuentra "+ itemdic.nombre(quest.buscar(),juego.idioma())}
	method changeQuest(){
		if(!juego.objetos().isEmpty())juego.removerObjetos()
		quest=listquest.list().anyOne()
		juego.agregarObjetos(quest.objetos())
	}
}

object personaje{
	//constante de velocidad para el manejo de sprite
	const velo=50
	var movimiento=2
	var property x=50
	var property y=50	
	var sentido=opcionpersonaje.down()
	var property image ="personaje/0.png"
	method medio(){return [x+16,y+16]}
	method position() = game.at(x,y) 
	method reset(){ x=50 y=50}
	method avanzar(a,b){
	}
		
	method mover(opcion){
		sentido=opcion
		if(opcion==opcionpersonaje.up()){ 
			if(!juego.isColisiones(self,0,4))
				movimiento=opcionmovimiento.caminar()
			else
				movimiento=opcionmovimiento.colisiona()
				self.up()
		}
		if(opcion==opcionpersonaje.down()){ 
			if(!juego.isColisiones(self,0,-4))
				movimiento=opcionmovimiento.caminar()
			else
				movimiento=opcionmovimiento.colisiona()
				self.down()
		}
		if(opcion==opcionpersonaje.left()){
			if(!juego.isColisiones(self,-4,0))
				movimiento=opcionmovimiento.caminar()
			else
				movimiento=opcionmovimiento.colisiona()
				self.left()
		}
		if(opcion==opcionpersonaje.right()){ 
			if(!juego.isColisiones(self,4,0))
				movimiento=opcionmovimiento.caminar()
			else
				movimiento=opcionmovimiento.colisiona()
				self.right()
		}
		
	}
	method interactuar(){
		var toco
		if(sentido==opcionpersonaje.up()){toco=juego.colisiones(self,0,8)}
		if(sentido==opcionpersonaje.down()){toco=juego.colisiones(self,0,-8)}
		if(sentido==opcionpersonaje.left()){toco=juego.colisiones(self,-8,0)}
		if(sentido==opcionpersonaje.right()){toco=juego.colisiones(self,8,0) }
		if(toco!=[]){
			if(toco.get(0).item().n()==maestro.quest().buscar()) {
				juego.puntos().correcto()
				game.say(maestro,"bien")
			}
			else{ 
				juego.puntos().falle()
				game.say(maestro,"fallaste")
			}
			if(juego.puntos().acierto()==5){
				juego.cambiarEscenario(1)
				juego.idioma(opcionlenguaje.ingles())
			}
			if(juego.puntos().acierto()==10){
				juego.idioma(opcionlenguaje.japones())
			}
			if(juego.puntos().intentos()==25){
				juego.end()
			}
			else{
				maestro.changeQuest()
				game.schedule(3000,{game.say(maestro,maestro.indicar())})
		
				}
		}	
	}
	method up(){
		
		game.schedule(velo, { image ="personaje/9.png"  })
		game.schedule(velo*2, { image ="personaje/10.png"  })
		game.schedule(velo*3, { image ="personaje/9.png" y+=movimiento })
		game.schedule(velo*4, { image ="personaje/11.png"  })
		game.schedule(velo*5, { image ="personaje/9.png" y+=movimiento })
	}
	method down(){
		game.schedule(velo*1, { image ="personaje/0.png" })
		game.schedule(velo*2, { image ="personaje/1.png" })
		game.schedule(velo*3, { image ="personaje/0.png" y-=movimiento })
		game.schedule(velo*4, { image ="personaje/2.png" })
		game.schedule(velo*5, { image ="personaje/0.png" y-=movimiento })
	}
	method left(){
		game.schedule(velo*1, { image ="personaje/3.png" })
		game.schedule(velo*2, { image ="personaje/4.png" })
		game.schedule(velo*3, { image ="personaje/3.png" x-=movimiento })
		game.schedule(velo*4, { image ="personaje/5.png" })
		game.schedule(velo*5, { image ="personaje/3.png" x-=movimiento })
	}
	method right(){
		game.schedule(velo*1, { image ="personaje/6.png"  })
		game.schedule(velo*2, { image ="personaje/7.png"  })
		game.schedule(velo*3, { image ="personaje/6.png" x+=movimiento })
		game.schedule(velo*4, { image ="personaje/8.png"  })
		game.schedule(velo*5, { image ="personaje/6.png" x+=movimiento })
	}

}
//maneja el puntero del menu principal
object puntero{
	const property inicio=0
	const property lenguaje=1
	const property salir=2
	var property image="items/18.png"
	var property x=2*16
	var property y=9*16
	var property opcion = 0
	method position() = game.at(x,y)
	//cambia la posicion del puntero  
	method position(_opcion){
		if(_opcion==inicio) y=9*16
		if(_opcion==lenguaje) y=6*16
		if(_opcion==salir) y=3*16
	}
	method up(){
		if (opcion == inicio) opcion = salir 
		else opcion--
		self.position(opcion)
	}
	method down(){
		if (opcion == salir) opcion = inicio 
		else opcion++
		self.position(opcion)
	}
	method left(){
		if (juego.idioma()==opcionlenguaje.espanol()) juego.idioma(opcionlenguaje.ingles())
		if (juego.idioma()==opcionlenguaje.ingles()) juego.idioma(opcionlenguaje.japones())
		if (juego.idioma()==opcionlenguaje.japones()) juego.idioma(opcionlenguaje.espanol())
	}
	method right(){
		if (juego.idioma()==opcionlenguaje.espanol()) juego.idioma(opcionlenguaje.japones())
		if (juego.idioma()==opcionlenguaje.ingles())  juego.idioma(opcionlenguaje.espanol())
		if (juego.idioma()==opcionlenguaje.japones()) juego.idioma(opcionlenguaje.ingles())
	}
	method enter(){
		if(opcion==0){
			juego.liberar()			
			juego.preconfig()
			juego.juego()
		}
		if(opcion==2){
			game.stop()
		}
	}
	
}
//maneja el puntero del menu de pausa
object subpuntero{

	var property image="items/18.png"
	var property x=2*16
	var property y=9*16
	var property opcion = 0
	method position() = game.at(x,y) 
	
	method position(_opcion){
		if(_opcion==opcionsubmenu.reinicio()) y=8*16
		if(_opcion==opcionsubmenu.salir()) y=4*16
	}
	method up(){
		if (opcion == opcionsubmenu.reinicio()) opcion = opcionsubmenu.salir()
		if (opcion == opcionsubmenu.salir()) opcion = opcionsubmenu.reinicio()
		self.position(opcion)
	}
	method down(){
		self.up()
	}
	method enter(){
		if(opcion==opcionsubmenu.reinicio()){
			juego.liberar()			
			juego.preconfig()
			juego.juego()
		}
		if(opcion==opcionsubmenu.salir()){
			game.stop()
		}
	}
	
}

object teclado {
	//enum de la opciones de la config del teclado
	
	method setConfig(tipo) {
		//configuro el teclado para solo funcione el menu
		if (tipo == opcionteclado.menu()) { 
			keyboard.up().onPressDo({ puntero.up()})
			keyboard.down().onPressDo({ puntero.down()})
			keyboard.left().onPressDo({ puntero.left()})
			keyboard.right().onPressDo({ puntero.right()})
			keyboard.enter().onPressDo({ puntero.enter()})
		}
		//configuro el teclado para solo funcione el menu de pausa
		if (tipo == opcionteclado.submenu()) { 
			keyboard.up().onPressDo({ subpuntero.up()})
			keyboard.down().onPressDo({ subpuntero.down()})
			keyboard.enter().onPressDo({ subpuntero.enter()})
		}
		//configuro el teclado para solo funcione el juego
		if (tipo == opcionteclado.juego()) {
			keyboard.up().onPressDo({ personaje.mover(opcionpersonaje.up())})
			keyboard.down().onPressDo({ personaje.mover(opcionpersonaje.down())})
			keyboard.left().onPressDo({ personaje.mover(opcionpersonaje.left())})
			keyboard.right().onPressDo({ personaje.mover(opcionpersonaje.right())})
			keyboard.any().onPressDo({var texto=maestro.texto()
				if(texto!="")game.say(maestro, maestro.texto())
			})
			keyboard.space().onPressDo({ personaje.interactuar()})
			keyboard.r().onPressDo({ personaje.reset()})
			keyboard.q().onPressDo({ juego.submenu()})
		}
	}

}

object menudic{
	var property list	
	
	method load(){
		list= new Dictionary()
		list.put("titulo","menu/titulo.png")
		list.put("titulo2","menu/titulo2.png")
		list.put("reiniciar","menu/reiniciar.png")
		list.put("inicio","menu/inicio.png")
		list.put("idioma","menu/idioma.png")
		list.put("salir" ,"menu/salir.png")
		list.put("espanol"   ,"menu/espanol.png")
		list.put("ingles"   ,"menu/ingles.png")
		list.put("japones"   ,"menu/japones.png")
	}
}

class Anuncios{
	var property x
	var property y
	var property text = ""
	var property textColor
//	var property image
	method position(){return game.at(x*16,y*16)}
}


