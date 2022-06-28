//unica forma de reemplazar enum de java
object opcionlenguaje{
	const property espanol=0
	const property ingles=1
	const property japones=2 
	
	method toString(dato){
		if(dato==espanol) return "espanol"
		if(dato==ingles) return "ingles"
		if(dato==japones) return "japones"
		return ""
	}
}

object opcionteclado{
	const property menu=0
	const property submenu=1
	const property juego=2 
}
object opcionpersonaje{
	const property up=0
	const property down=-1
	const property left=-2
	const property right=2 
}
object opcionmenu{
	const property inicio=0
	const property lenguaje=1
	const property salir=2 
}
object opcionsubmenu{
	const property reinicio=0
	const property salir=1 
}
object opcionmovimiento{
	const property colisiona=0
	const property caminar=2
}