import Opciones.*

class Item{
	var property n
	var property image
	var property esp
	var property eng
	var property jap

	method idioma(opcion){
		if(opcion==opcionlenguaje.espanol()) return esp
		if(opcion==opcionlenguaje.ingles()) return eng
		if(opcion==opcionlenguaje.japones()) return jap
		return ""
	}
}

object itemdic{
	
	var property list	
	
	method load(){
		list= new Dictionary()
		list.put("19",new Item(n = "19",image = "items/19.png",esp ="anillo"   ,eng= "ring" ,jap="Yubiwa"))
		list.put("25",new Item(n = "25",image = "items/25.png",esp ="monedas"  ,eng="coin"  ,jap="Tsuka"))
		list.put("26",new Item(n = "26",image = "items/26.png",esp ="rubi"     ,eng="ruby"  ,jap="rubi"))
		list.put("27",new Item(n = "27",image = "items/27.png",esp ="cofre"    ,eng= "chest",jap="Mune"))
		list.put("28",new Item(n = "28",image = "items/28.png",esp ="llave"    ,eng= "key"  ,jap="Renchi"))
		list.put("29",new Item(n = "29",image = "items/29.png",esp ="carne"    ,eng= "meal" ,jap="Niku"))
		list.put("30",new Item(n = "30",image = "items/30.png",esp ="manzana"  ,eng= "apple",jap="Ringo"))
		list.put("31",new Item(n = "31",image = "items/31.png",esp ="zanahoria",eng="carrot",jap="Ninjin"))
		list.put("33",new Item(n = "33",image = "items/33.png",esp ="pescado"  ,eng= "fish" ,jap="Sakana"))
		list.put("37",new Item(n = "37",image = "items/37.png",esp ="corazon"  ,eng= "heart",jap="Shinzō"))
		list.put("46",new Item(n = "46",image = "items/46.png",esp ="ojo"      ,eng= "eye"  ,jap="Me"))
	}
	method nombre(num,idioma){
		return list.get(num).idioma(idioma)
	}
}

