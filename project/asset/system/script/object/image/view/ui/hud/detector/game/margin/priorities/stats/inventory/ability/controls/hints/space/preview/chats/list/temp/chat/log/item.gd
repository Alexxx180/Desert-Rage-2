extends Label

var items: Array[String] = [
	"А что нашлось то тут у нас... %s", "%s? Отдавай сундук!",
	"%s, по сусекам наскреб", "%s с нами", "Тук-тук, кто там? %s",
	"Давно не виделись, %s", "Прошу на борт, %s", "Глянем... %s",
	"Вот это %s, я понимаю", "%s моей мечты",
	"%s... а подтираться этим можно?"]

func say(message: String, params: Array = []) -> void:
	text = message % params

func chest(item: String) -> void:
	print("ADD ITEM = ", item)
	say(items.pick_random(), [item])

func analyze(enemy: String) -> void:
	say("Сведения о %s добавлены в базу данных", [enemy])
