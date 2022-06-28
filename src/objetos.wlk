import wollok.game.*
import objects.*

class Objeto{
	var property x=0
	var property y=0
	var property image=""
	method position()= game.at(x,y)
//	method medio(){return [x+8,y+8]}
}

class ObjetoIntereactivo inherits Objeto{
	var property item
}

//fabrica que construye el fondo del juego
class FactorySoil{
	var property type
	const list = ["0.png","1.png","2.png","3.png","4.png","5.png","6.png","7.png"]
	method make(x,y){
		return new Objeto(x = x*16, y = y*16, image = list.get(type) )
	}
	method make(x,y,t){
		type=t
		return self.make(x,y)
	}
	
	method makeMap(lista){
		/*
		 return lista.map({p=>{	
		 	return self.make(p.get(0),p.get(1),p.get(2))
		 }})*/
		var _lista=[]
		 lista.forEach({p=>_lista.add(self.make(p.get(0),p.get(1),p.get(2)))		 })
		 return _lista
	}
}
//fabrica que construye los item del juego
class FactoryItem{
	var property type

	method make(x,y,t){
		return new ObjetoIntereactivo(x = x*16 ,y = y*16 ,image = itemdic.list().get(t).image(),item=itemdic.list().get(t))
	}
//Recibe una lista de objetos y los construye en el escenario
 	method makes(l){
		var lista=[]
		l.forEach({p=>lista.add(self.make(p.get(0), p.get(1), p.get(2)))})
		return lista
	}
}



