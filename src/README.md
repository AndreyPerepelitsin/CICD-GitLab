# Basic CI/CD

Разработка простого **CI/CD** для проекта *SimpleBashUtils*. Сборка, тестирование, развертывание.


## Contents

1. [Part 1. Настройка gitlab-runner](#part-1-настройка-gitlab-runner)  
2. [Part 2. Сборка](#part-2-сборка)  
3. [Part 3. Тест кодстайла](#part-3-тест-кодстайла)   
4. [Part 4. Интеграционные тесты](#part-4-интеграционные-тесты)  
5. [Part 5. Этап деплоя](#part-5-этап-деплоя)  
6. [Part 6. Дополнительно. Уведомления](#part-6-дополнительно-уведомления)


## Part 1. Настройка gitlab-runner
    - Поднимем виртуальную машину *Ubuntu Server 22.04 LTS*.
    - Настроим конфигурацию в yaml-файле:
    $ sudo vim /etc/netplan/00-installer-config.yaml  i  ...  :wq  
    $ sudo netplan apply
![basic_cicd](./images/netplan.png)

    - Установим необходимые настройки на VM DO6CICD:
        $ sudo apt-get update && apt-get upgrade -y
    - Затем проверим версии curl, gcc, make, clang-format, gitlab-runner. 
        Если что-то не найдено, то:
        $ sudo apt-get install -y curl gcc make clang-format
        $ sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash ```
        $ sudo apt-get install -y gitlab-runner.
        Настроим и включим ssh на VM DO6_server и на VM DO6Deploy:\
        $ sudo apt-get install openssh-server
        $ sudo rm -rf /var/lib/apt/lists/*
        $ sudo service ssh start
    - Загрузим и запустим установочный скрипт GitLab-Runner:
    
    $ sudo curl -LJO "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/deb/gitlab-runner_amd64.deb"

    - Установим GitLab-Runner:
    $ sudo dpkg -i gitlab-runner_amd64.deb
![basic_cicd](./images/1_1.png)

    - Проверим версию:
    $ sudo gitlab-runner -version

    - Запустим GitLab-Runner
    $ sudo gitlab-runner start

    - Проверим статус запуска:
    $ sudo gitlab-runner status

![basic_cicd](./images/1_2.png)

    - Зарегистрируем GitLab-Runner в GitLab чтобы связать наш runner c проектами в нашей учетной записи GitLab,
    который поможет в выполнении задач CI/CD.
    $ sudo gitlab-runner register
       
        instance URL: https://repos.21-school.ru
    	token: токен пользователя (см. в описании проекта на https://edu.21-school.ru/project/...)
    	description: DO6_server-1 ci/cd-runner
    	tags: build, stylecheck, test, deploy, alert
    	note: примечание
    	executor: shell
    
![basic_cicd](./images/1_3.png)

    - Перезагрузим раннер:
    $ sudo systemctl restart gitlab-runner

    - Посмотрим регистрацию раннера:
    $ sudo cat /etc/gitlab-runner/config.toml 

    - Проверим работу раннера (должно быть is alive):
    $ sudo gitlab-runner verify

![basic_cicd](./images/1_4.png)

    - Если не установлен gcc, необходимо установить: $ sudo apt install gcc

    - Теперь напишем сценарий, кторый будет автоматически запускаться с каждым git push. 
    (Описано в следующей главе.)


## Part 2. Сборка

    Напишем этап для CI по сборке приложений из проекта C2_SimpleBashUtils. 
    Для этого в файле gitlab-ci.yml добавим этап запуска сборки через мейк файл из проекта С2.
    Файлы, полученные после сборки (артефакты), сохраним в произвольную директорию со сроком хранения 30 дней.

    Подготовка: 
        1. В наш CI/CD проект, в папку src вставим и запушим папки cat и grep из проекта C2_SimpleBashUtils.
        2. На виртуальной машине должны быть установлены gcc, clang-format и остальные необходимые утилиты.

    - В браузере -> GitLab -> CI/CD проект -> слева в меню выберем: CI/CD -> Editor.

![basic_cicd](./images/2_1.png)

    - В предложенном шаблоне-файле gitlab-ci.yml опишем сборку проекта и подтвердим commit:

![basic_cicd](./images/2_2.png)

    - При необходимости можно использовать переменные GitLab CI/CD из списка в документации:
    https://docs.gitlab.com/ee/ci/variables/index.html

    - После git push активируется этот сценарий, и его процесс можно увидеть как 
    Pipeline (Конвейер) сборки проекта в браузере, в GitLab в проекте.

![basic_cicd](./images/2_3.png)

![basic_cicd](./images/2_4.png)

    - В виртуальной машине можно заглянуть в клонированный раннером проект:
    $ ls /home/gitlab-runner/builds/

## Part 3. Тест кодстайла 

    Напишем этап для CI, который запускает скрипт кодстайла (clang-format).
![basic_cicd](./images/3_1.png)

    Если кодстайл не прошел, то «зафейлим» пайплайн.
![basic_cicd](./images/3_3.png)
![basic_cicd](./images/3_2.png)

    В пайплайне отобразим вывод утилиты clang-format. Теперь мы увидим, как исполняются два задания (jobs).
![basic_cicd](./images/3_4.png)

## Part 4. Интеграционные тесты

    - Напишем этап для CI, который запускает наши интеграционные тесты из того же проекта.

![basic_cicd](./images/4_1.png)

    - Запустим этот этап автоматически только при условии, если сборка и тест кодстайла прошли успешно.
    Если тесты не прошли, то «зафейли» пайплайн.
    - В пайплайне отобрази вывод, что интеграционные тесты успешно прошли / провалились.
![basic_cicd](./images/4_2.png)

## Part 5. Этап деплоя

1) Поднимем вторую виртуальную машину Ubuntu Server 22.04 LTS.
    - Склонируем вторую виртуальную машину и назовем ее DO6Deploy.
    
    - Установим необходимые настройки на VM DO6Deploy:
        ```$ sudo apt-get update && apt-get upgrade -y```. \
        Затем проверим версии curl, gcc, make, clang-format, gitlab-runner. 
            (Если что-то не найдено, то: \
            ```$ sudo apt-get install -y curl gcc make clang-format```
            ```$ sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash ```
            ```$ sudo apt-get install -y gitlab-runner```).
        Настроим и включим ssh на VM DO6_server и на VM DO6Deploy:\
        ```$ sudo apt-get install openssh-server```\
        ```$ sudo rm -rf /var/lib/apt/lists/*```\
        ```$ sudo service ssh start```
    
2) Настроим конфигурации машин, чтобы связать их друг с другом.\  
        Здесь могут помочь знания, полученные в проекте DO2_LinuxNetwork.:\
        ```$ sudo vim /etc/netplan/00-installer-config.yaml  i  ...  :wq```\   
        ```$ sudo netplan apply```
![basic_cicd](./images/5_1.png) 

    - На VM DO6_server перейдем на пользователя gitlab-runner:\
        ```$ sudo su gitlab-runner```\
![basic_cicd](./images/5_2.png)

    - На VM DO6_server вернемся на суперпользователя и даем больше прав пользователю 
        gitlab-runner:\
    ```$ sudo usermod -aG sudo gitlab-runner```\
![basic_cicd](./images/5_6.png) 
    
    - На VM DO6Deploy создаем нового пользователя deploy-user и даем права к директории /usr/local/bin, 
    чтобы иметь возможность «развернуть» проект, который получим от VM DO6_server:\
    ```$ sudo chown deploy-user /usr/local/bin/```\
![basic_cicd](./images/5_7.png) 

    - Сгенерируем ssh-ключ: $ ssh-keygen\
      Можно использовать "ssh-keygen -R hostname"   -R hostname - удаляет все ключи, принадлежащие hostname, из файла known_hosts. Эта опция 
 полезна для удаления хэшированных хостов.\
    Полезная ссылка: https://docs.gitlab.com/ee/ci/ssh_keys/
      
![basic_cicd](./images/5_3.png)

    - Копируем ssh-ключ с DO6_server на VM DO6Deploy, указывая пользователя и адрес:\
    ```$ ssh-copy-id deploy-user@10.21.2.15```\
![basic_cicd](./images/5_4.png)

    - На VM DO6Deploy можно проверить скопировался ли ключ:\
        ```$ cat ~/.ssh/authorized_keys```\
![basic_cicd](./images/5_5.png)  
        Или же можно посмотреть здесь:  $ sudo cat .ssh/known_hosts.\
        В OpenSSH список известных ключей серверов хранится в файле known_hosts.

3) Напишем этап для CD, который «разворачивает» проект на другой виртуальной машине. 

    
    - Напишем bash-скрипт в папке src, который при помощи ssh и scp копирует файлы, 
    полученные после сборки (артефакты), в директорию /usr/local/bin 
    второй виртуальной машины.
    
    Что такое **scp**? scp (Secure Copy Command) - это утилита, 
    которая работает по протоколу SSH.\
    В нашем случае на VM DO6Deploy мы запустили SSH сервер, и VM DO6_server знает адрес для перемещения файлов.
    Как только мы совершаем команду git push, gitlub-runner получает всю новую информацию после Continuous Integration 
    (файлы, полученные после сборки (артефакты)).\
    Далее происходит следующий шаг - Continuous Delivery - когда раннер отправляет информацию (артефакты) на DO6Deploy, 
    на котором потом разворачивается проект. 
    Артефакты сохраняются в директорию /usr/local/bin, 
    для которой мы дали права записи пользователю fridamag на VM DO6Deploy.\
    
    Поэтому команда scp поможет нам передать файлы от раннера (DO6_server) к DO6Deploy.
![basic_cicd](./images/5_8.png) 
    
    - Нам понадобится описать задание для раннера в gitlab-ci.yml.\
    Здесь мы добавим этап запуска написанного скрипта deploy.sh.\
    Чтобы остановить выполнение конвейером последующих заданий, используем allow_failure: false. 
    Чтобы указать задание как ручное, добавим when: manual к заданию в .gitlab-ci.yml файл.
    По умолчанию ручные задания отображаются как пропущенные при запуске конвейера.\
    (Не забудем запушить наши изменения в проекте!)\
![basic_cicd](./images/5_9.png)

4) Запустим этот этап вручную при условии, что все предыдущие этапы прошли успешно.

    - В случае ошибки «зафейлим» пайплайн.
![basic_cicd](./images/5_10.png)


    - Запустим пайплайн снова:

![basic_cicd](./images/5_13.png)

В результате получим готовые к работе приложения из проекта C2_SimpleBashUtils (s21_cat и s21_grep) на второй виртуальной машине.

![basic_cicd](./images/5_14.png)

Сохраним дампы образов виртуальных машин.
P.S. Ни в коем случае не сохраняем дампы в гит!
Не забудим запустить пайплайн с последним коммитом в репозитории.

## Part 6. Дополнительно. Уведомления

 - Настроим уведомления о успешном/неуспешном выполнении 
 пайплайна через бота с именем «[fridamag] DO6 CI/CD» в Telegram.
Текст уведомления должен содержать информацию об успешности 
прохождения как этапа CI, так и этапа CD.
В остальном текст уведомления может быть произвольным.

 - В строке поиска контактов в telegram ищем @botfather

 - Запускаем его кнопкой Start, 
    вводим команду /newbot и отвечаем на вопросы. 
    Нужно иметь ввиду, что name — это имя бота, 
    которое будет отображаться пользователям, 
    а username — уникален и должен завершаться на «bot».

![basic_cicd](./images/6_0.png)

 - Среди прочего, бот выдаст секретный токен для HTTP API,
  который нужно скопировать и сохранить в файл tg_bot.sh в TELEGRAM_BOT_TOKEN.

- Создадим новый файл tg_bot.sh:
![basic_cicd](./images/6_1.png)

- В файле .gitlab-ci.yml добавим к каждому заданию кроме деплоя:
  after_script:
    - bash src/tg_bot.sh "build"
![basic_cicd](./images/6_3.png)    

- Сделаем коммит и посмотрим как всё соберется:
![basic_cicd](./images/6_4.png)    
