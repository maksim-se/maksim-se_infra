# maksim-se_infra

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
