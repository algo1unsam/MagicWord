/** First Wollok example */
import wollok.game.*
import objetos.*
import objects.*
import quest.*
import maps.*
object juego {
	const fabrica = new FactorySoil(type=0)
	const fabricaitem = new FactoryItem(type=0)
	var property puntos 
	var listcolisiones = []
	var property objetos=[]
	var textura = []
	var property idioma = "esp"
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
		console.println(menudic.list().get("inicio"))
		var opcion=0
		var opciones=["esp","eng","jap"]
		self.cambiarEscenario(-1)					
		var titulos=[]
		titulos.add(new Objeto(x=0*16,y=10*16,image=menudic.list().get("titulo")))
		titulos.add(new Objeto(x=4*16,y=9*16,image=menudic.list().get("inicio")))
		titulos.add(new Objeto(x=4*16,y=6*16,image=menudic.list().get("idioma")))
		titulos.add(new Objeto(x=4*16,y=3*16,image=menudic.list().get("salir")))
		titulos.forEach({p => game.addVisual(p)})	
		var tidioma = new Objeto(x=8*16,y=6*16,image=menudic.list().get(idioma))
		game.addVisual(tidioma)
		game.addVisual(puntero)
		teclado.setConfig("menu")
	}
	method submenu(){
		var auxtextura=textura
		self.cambiarEscenario(-1)
		var titulos=[]
		titulos.add(new Objeto(x=0*16,y=11*16,image=menudic.list().get("titulo2")))
		titulos.add(new Objeto(x=4*16,y=8*16,image=menudic.list().get("reiniciar")))
		titulos.add(new Objeto(x=4*16,y=4*16,image=menudic.list().get("salir")))
		titulos.forEach({p => game.addVisual(p)})	
	}
	method juego(){
		puntos=new puntuacion()
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
			game.addVisual(new anuncios(x=2,y=10,text="juego perfecto",textColor="00FF00FF"))
		}		
		else if(puntos.acierto()>puntos.fracaso()){
			self.cambiarEscenario(-4)
			game.addVisual(new anuncios(x=2,y=10,text="ganaste",textColor="00FF00FF"))
		}
		else{
			self.cambiarEscenario(-3)
			game.addVisual(new anuncios(x=2,y=10,text="fallaste",textColor="FF0000FF"))
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
		textura.forEach({p => game.addVisual(p)})
		if(escenario>=0){
			game.addVisual(personaje)
		    game.addVisual(maestro)
			if(!listcolisiones.contains(maestro))listcolisiones.add(maestro)
			teclado.setConfig("juego")
		}
	}
	
	method agregarObjetos(objs){
		objetos=fabricaitem.makes(objs)
		objetos.forEach({o=>game.addVisual(o) listcolisiones.add(o)})
	}
	
	method isColision(obj1,obj2,a,b){
		if ( obj1.x()+a > obj2.x()+16 ) return false
		if ( obj1.x()+16+a < obj2.x() ) return false
		if ( obj1.y()+b > obj2.y()+16 ) return false
		if ( obj1.y()+21+b < obj2.y() ) return false
		return true		
	}
	
	method isColisiones(obj1,a,b){
		return !listcolisiones.all{obj=>!self.isColision(obj1,obj,a,b)}
	}
	
	method colisiones(obj1,a,b){
		return listcolisiones.filter{obj=>self.isColision(obj1,obj,a,b)==true }
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
	const velo=50
	var property x=50
	var property y=50
	var sentido="down"
	var property image ="personaje/0.png"
	method medio(){return [x+16,y+16]}
	method position() = game.at(x,y) 
	method reset(){ x=50 y=50}
	method avanzar(a,b){
	}
		
	method mover(a){
		sentido=a
		if(a=='up'){ 
			if(!juego.isColisiones(self,0,4))
				self.up()
			else
				self.up_of()	
		}
		if(a=='down'){ 
			if(!juego.isColisiones(self,0,-4))
				self.down()	
			else
				self.down_of()	
		}
		if(a=='left'){
			if(!juego.isColisiones(self,-4,0))
				self.left()
			else
				self.left_of()	
		}
		if(a=='right'){ 
			if(!juego.isColisiones(self,4,0))
				self.right()
			else
				self.right_of()	
		}
		
	}
	method interactuar(){
		var toco
		if(sentido=='up'){toco=juego.colisiones(self,0,8)}
		if(sentido=='down'){toco=juego.colisiones(self,0,-8)}
		if(sentido=='left'){toco=juego.colisiones(self,-8,0)}
		if(sentido=='right'){toco=juego.colisiones(self,8,0) }
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
				juego.idioma("eng")
			}
			if(juego.puntos().acierto()==10){
				juego.idioma("jap")
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
		game.schedule(velo*3, { image ="personaje/9.png" y+=2 })
		game.schedule(velo*4, { image ="personaje/11.png"  })
		game.schedule(velo*5, { image ="personaje/9.png" y+=2 })
	}
	method down(){
		game.schedule(velo*1, { image ="personaje/0.png" })
		game.schedule(velo*2, { image ="personaje/1.png" })
		game.schedule(velo*3, { image ="personaje/0.png" y-=2 })
		game.schedule(velo*4, { image ="personaje/2.png" })
		game.schedule(velo*5, { image ="personaje/0.png" y-=2 })
	}
	method left(){
		game.schedule(velo*1, { image ="personaje/3.png" })
		game.schedule(velo*2, { image ="personaje/4.png" })
		game.schedule(velo*3, { image ="personaje/3.png" x-=2 })
		game.schedule(velo*4, { image ="personaje/5.png" })
		game.schedule(velo*5, { image ="personaje/3.png" x-=2 })
	}
	method right(){
		game.schedule(velo*1, { image ="personaje/6.png"  })
		game.schedule(velo*2, { image ="personaje/7.png"  })
		game.schedule(velo*3, { image ="personaje/6.png" x+=2 })
		game.schedule(velo*4, { image ="personaje/8.png"  })
		game.schedule(velo*5, { image ="personaje/6.png" x+=2 })
	}
	method up_of(){
		game.schedule(velo, { image ="personaje/9.png"    })
		game.schedule(velo*2, { image ="personaje/10.png" })
		game.schedule(velo*3, { image ="personaje/9.png"    })
		game.schedule(velo*4, { image ="personaje/11.png" })
		game.schedule(velo*5, { image ="personaje/9.png"  })
	}
	method down_of(){
		game.schedule(velo*1, { image ="personaje/0.png" })
		game.schedule(velo*2, { image ="personaje/1.png" })
		game.schedule(velo*3, { image ="personaje/0.png" })
		game.schedule(velo*4, { image ="personaje/2.png" })
		game.schedule(velo*5, { image ="personaje/0.png" })
	}
	method left_of(){
		game.schedule(velo*1, { image ="personaje/3.png" })
		game.schedule(velo*2, { image ="personaje/4.png" })
		game.schedule(velo*3, { image ="personaje/3.png" })
		game.schedule(velo*4, { image ="personaje/5.png" })
		game.schedule(velo*5, { image ="personaje/3.png" })
	}
	method right_of(){
		game.schedule(velo*1, { image ="personaje/6.png" })
		game.schedule(velo*2, { image ="personaje/7.png" })
		game.schedule(velo*3, { image ="personaje/6.png" })
		game.schedule(velo*4, { image ="personaje/8.png" })
		game.schedule(velo*5, { image ="personaje/6.png" })
	}
	
}

object puntero{
	var property image="items/18.png"
	var property x=2*16
	var property y=9*16
	var property opcion = 0
	method position() = game.at(x,y) 
	method position(a){
		if(a==0) y=9*16
		if(a==1) y=6*16
		if(a==2) y=3*16
	}
	method up(){
		if (opcion == 0) opcion = 2 
		else opcion--
		self.position(opcion)
	}
	method down(){
		if (opcion == 2) opcion = 0 
		else opcion++
		self.position(opcion)
	}
	method left(){
		if (juego.idioma()=="esp") juego.idioma("eng")
		if (juego.idioma()=="eng") juego.idioma("jap")
		if (juego.idioma()=="jap") juego.idioma("esp")
	}
	method right(){
		if (juego.idioma()=="esp") juego.idioma("jap")
		if (juego.idioma()=="eng") juego.idioma("esp")
		if (juego.idioma()=="jap") juego.idioma("eng")
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
object subpuntero{
	var property image="items/18.png"
	var property x=2*16
	var property y=9*16
	var property opcion = 0
	method position() = game.at(x,y) 
	method position(a){
		if(a==0) y=8*16
		if(a==1) y=4*16
	}
	method up(){
		if (opcion == 0) opcion = 1
		if (opcion == 1) opcion = 0
		self.position(opcion)
	}
	method down(){
		self.up()
	}
	method enter(){
		if(opcion==0){
			juego.liberar()			
			juego.preconfig()
			juego.juego()
		}
		if(opcion==1){
			game.stop()
		}
	}
	
}

object teclado {

	method setConfig(tipo) {
		if (tipo == "menu") { 
			keyboard.up().onPressDo({ puntero.up()})
			keyboard.down().onPressDo({ puntero.down()})
			keyboard.left().onPressDo({ puntero.left()})
			keyboard.right().onPressDo({ puntero.right()})
			keyboard.enter().onPressDo({ puntero.enter()})
		}
		if (tipo == "sub") { 
			keyboard.up().onPressDo({ subpuntero.up()})
			keyboard.down().onPressDo({ subpuntero.down()})
			keyboard.enter().onPressDo({ subpuntero.enter()})
		}
		if (tipo == "juego") {
			keyboard.up().onPressDo({ personaje.mover('up')})
			keyboard.down().onPressDo({ personaje.mover('down')})
			keyboard.left().onPressDo({ personaje.mover('left')})
			keyboard.right().onPressDo({ personaje.mover('right')})
			keyboard.any().onPressDo({var a=maestro.texto()
				if(a!="")game.say(maestro, maestro.texto())
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
		list.put("esp"   ,"menu/espanol.png")
		list.put("eng"   ,"menu/ingles.png")
		list.put("jap"   ,"menu/japones.png")
	}
}

class anuncios{
	var property x
	var property y
	var property text = ""
	var property textColor
//	var property image
	method position(){return game.at(x*16,y*16)}
}


