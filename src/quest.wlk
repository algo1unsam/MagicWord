object listquest{
	var property list=[]
	method load(){
		list.add(new Quest(buscar="31",objetos=[[3,11, '31'],[5,11, '25'],[7,11, '26'],[9,11, '27']]))
		list.add(new Quest(buscar="31",objetos=[[3,11, '46'],[5,11, '19'],[7,11, '37'],[9,11, '31']]))
		list.add(new Quest(buscar="25",objetos=[[3,11, '30'],[5,11, '25'],[7,11, '19'],[9,11, '31']]))
		list.add(new Quest(buscar="26",objetos=[[3,11, '29'],[5,11, '19'],[7,11, '26'],[9,11, '31']]))
		list.add(new Quest(buscar="31",objetos=[[3,11, '19'],[5,11, '27'],[7,11, '25'],[9,11, '31']]))
		list.add(new Quest(buscar="31",objetos=[[3,11, '31'],[5,11, '26'],[7,11, '28'],[9,11, '30']]))
		list.add(new Quest(buscar="46",objetos=[[3,11, '33'],[5,11, '46'],[7,11, '26'],[9,11, '31']]))
	}
}


class Quest{
	var property buscar
	var property objetos
}
class Puntuacion{
	var property acierto=0
	var property fracaso=0
	method intentos(){return fracaso+acierto}
	method correcto()=acierto++
	method falle()=fracaso++
}