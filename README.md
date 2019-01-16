# maksim-se_infra
	--- Описание дом. задания №7
   - проект был разбит на модули: app, db, vpc
   - были созданы 2 среды prod, stage. Среды настроены на одновременную работу.
   - настроен модуль storage-bucket на хранение файлов terraform (tfstate)
   - проверил работу блокировок

Error: Error locking state: Error acquiring the state lock: writing "gs://sb-prod/terraform/prod/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
  ID:        1543941633309686
  Path:      gs://sb-prod/terraform/prod/default.tflock
  Operation: OperationTypeApply
  Who:       maksim@yoga-11s
  Version:   0.11.10
  Created:   2018-12-04 16:40:33.155098399 +0000 UTC
  Info:      


  -  добавлено создание сервисов с помощью provisioner

  --- Описание дом. задания №6

Для добавления нового пользователя appuser1 и его ключа в метаданные проекта было сделано следующее:

	в ресурс google_compute_instance секция metadata был добавлена строка
	`ssh-keys = "appuser1:${file(var.public_key_path)}"`

	После применения изменений у сервера reddit-app повился еще один пользователь с ключем для доступа appuser1

Для добавления спииска пользователей описываем пользователей в новой секции:
		resource "google_compute_project_metadata" "ssh_userkeys" {
		  metadata {
			ssh-keys = <<EOF
		appuser1:${file(var.public_key_path)}
		appuser2:${file(var.public_key_path)}
		appuser3:${file(var.public_key_path)}
			EOF
		  }
		}

После применения конфигурации новым пользователям добавился доступ по ключам

После добавления через веб-интерфейс пользователя appuser_web и применения конфигурации этого пользователя terraform удалил, так как его не было в конфигурации.

Задание со **

1. Был создан балансировщик, который перекидывал траффик на приложение reddit-app.
2. Добывлена еще одно нода reddit-app-2 дублированием кода существующей reddit-app. При остановке одной ноды в web-console в разделе балансировки появилось предупреждении о недоступности одного приложения. Через браузер прилоение доступно.
	Основная проблема такой конфигурации - это ДВЕ разные базы у приложений, соответственно разные версии "Reddit"

3. перепиисан код с использование параметра count для создания необходимого кол-ва серверов.Count занается в файле  terraform/terraform.tfvars и знание по-умолчанию (1) прописано в terraform/variables.tf

	--- Описание дом. задания №9

	Написаны 3 версии плейбуков для деплоя приложения.
	1. плейбук ввиде одного файла: ansible/reddit_app_one_play.yml
	2. плейбук ввиде трёх файлов: ansible/reddit_app_multiple_plays.yml
	3. плейбук ввиде 3 подзадач: ansible/site.yml
	Переписаны провиженеры packer с использованием плейбуков: ansible/packer_app.yml и ansible/packer_db.yml. Созданы новые образы для терраформа, развернуты инстансы  и и приложение:
			packer build -var-file=packer/variables.jsonpacker/db.json
			packer build -var-file=packer/variables.json packer/app.json
			ansible-playbook -i ansible/inventory ansible/site.yml
