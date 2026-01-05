# Дипломная работа. Андрей Осипенков

# Этапы выполнения:


## Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://developer.hashicorp.com/terraform/language/backend) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)
3. Создайте конфигурацию Terrafrom, используя созданный бакет ранее как бекенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках.
4. Создайте VPC с подсетями в разных зонах доступности.
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://developer.hashicorp.com/terraform/language/backend) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий, стейт основной конфигурации сохраняется в бакете или Terraform Cloud
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

### Решение

1.

[service_acc](https://github.com/Kovrei/netology_diplom/tree/main/src/service_acc) - конфигурация манифеста для сервис аккаунта с ролью админ  

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.1.2.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.1.1.JPG?raw=true)


2.
   
[backend](https://github.com/Kovrei/netology_diplom/tree/main/src/backend) - конфигурация манифеста backend. S3 bucket в созданном ЯО аккаунте(создание бакета через TF).

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.2.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.2.1.JPG?raw=true)

3. 

[Структура манифеста](https://github.com/Kovrei/netology_diplom/tree/main/src)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.3.JPG?raw=true)

4. 

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.4.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.5.JPG?raw=true)

5. 

[Script](https://github.com/Kovrei/netology_diplom/blob/main/src/script/setup-backend.sh) - скрипт для запуска манифестов  

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.5.1.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.5.2.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/1.5.3.JPG?raw=true)


---
## Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

### Решение

1. 

**- Клонирование в [структуру](https://github.com/Kovrei/netology_diplom/tree/main/src) [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)** 

**- Манифест [terraform](https://github.com/Kovrei/netology_diplom/tree/main/src/terraform) за счет опциональных файлов [ansible.tf](https://github.com/Kovrei/netology_diplom/blob/main/src/terraform/ansible.tf) и [inventory.tftpl](https://github.com/Kovrei/netology_diplom/blob/main/src/templates/inventory.tftpl) созадет файл [host.yaml](https://github.com/Kovrei/netology_diplom/blob/main/src/terraform/hosts.yaml) и копирует в    netology_diplom/src/kubespray/inventory/mycluster**

**- В папке kuberspray выполнить команду** 

`
ansible-playbook -i ./inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml  
`
![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/2.1.JPG?raw=true)

2. 

**- Выполнить команды**
`
mkdir -p ~/.kube && ssh aos@158.160.56.163 "sudo cat /root/.kube/config" >> ~/.kube/config

sed -i 's/127.0.0.1/158.160.56.163/g' ~/.kube/config
`

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/2.2.1.JPG?raw=true)

3.  

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/2.3.JPG?raw=true)



---
## Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

### Решение

`
docker build -t rei169kov/nginx:v1 .  

docker run -d -p 80:80 rei169kov/nginx:1.0  

docker login   

docker push rei169kov/nginx:1.0  

`

[github repo](https://github.com/Kovrei/app_diplom_mission3)  

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/3.1.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/3.2.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/3.3.JPG?raw=true)

1.  

[github repo](https://github.com/Kovrei/app_diplom_mission3)  

2.  

[dockerhub repo](https://hub.docker.com/r/rei169kov/nginx)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/3.4.JPG?raw=true)

---
## Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

## Деплой инфраструктуры в terraform pipeline

1. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
5. Atlantis или terraform cloud или ci/cd-terraform


### Решение

1. 

**- автоматическое создания для деплоя монитринга происходит при запуске terraform и настройки [monitoring.tf](https://github.com/Kovrei/netology_diplom/blob/main/src/terraform/monitoring.tf)**

**- В папке [~/netology_diplom/src/k8s-configs](https://github.com/Kovrei/netology_diplom/tree/main/src/k8s-configs) выполнить команды:**  


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts   

helm install kube-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

kubectl get secret --namespace monitoring -l app.kubernetes.io/component=admin-secret -o jsonpath="{.items[0].data.admin-password}" | base64 --decode ; echo  

kubectl get pods -o wide -n monitoring  

kubectl apply -f namespace.yaml -f deployment.yaml -f service.yaml  

kubectl get po -n diplom-nginx -o wide  

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx  

helm install my-nginx-ingress-controller ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.hostNetwork=true --set controller.service.enabled=false  

kubectl apply -f grafana-ingress.yaml  -f app-ingress.yaml  

**- внести изменения в configmap командой**  

KUBE_EDITOR="nano" kubectl -n monitoring edit cm kube-prometheus-grafana  

**- изменения:**  

[server]   
domain = 158.160.104.244   
root_url = http://158.160.104.244/monitor/    
serve_from_sub_path = true    
`
**- выполнить команду**  

`
kubectl -n monitoring rollout restart deploy/kube-prometheus-grafana  
`
![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.1.JPG?raw=true)

2.  

[grafana](https://github.com/Kovrei/netology_diplom/blob/main/src/k8s-configs/grafana-ingress.yaml)

3.

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.2.1.JPG?raw=true)

4.  
[nginx](https://github.com/Kovrei/netology_diplom/blob/main/src/k8s-configs/app-ingress.yaml)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.2.2.JPG?raw=true)

5. 

**- В папке [atlantis](https://github.com/Kovrei/netology_diplom/tree/main/src/k8s-configs/atlantis) выполнить команды:**  

`
kubectl apply -f atlantis_ns.yaml -f atlantis-secrets.yaml -f atlantis_cm.yaml -f atlantis_dt.yaml -f atlantis_svc.yaml  

kubectl get pods -o wide -n atlantis  
`

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.4.JPG?raw=true)

**- настройить webhook:**

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.5.1.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.5.2.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.5.3.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.5.4.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.5.5.JPG?raw=true)


---
## Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

### Решение

1  

**Выбрана стратегия CI/CD через Git Action**  

**- Настроены secrets в [github репозитории](https://github.com/Kovrei/app_diplom_mission3)**    

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/5.1.JPG?raw=true)

- настроен для CI/CD [workflows](https://github.com/Kovrei/app_diplom_mission3/blob/main/.github/workflows/pipi.yaml)  

2  

**- Автоматизация CI в github**

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/5.3.2.JPG?raw=true)

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/5.3.3.JPG?raw=true)

3  

**- Автоматизация CD в dockerhub**

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/5.4.1.JPG?raw=true)

**- актуализация изменения в http**

![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/5.4.2.JPG?raw=true)

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля. [структура](https://github.com/Kovrei/netology_diplom/tree/main/src)
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline. 
![alt text](https://github.com/Kovrei/netology_diplom/blob/main/img/4.5.5.JPG?raw=true)
3. Репозиторий с конфигурацией [ansible](https://github.com/Kovrei/netology_diplom/blob/main/src/terraform/ansible.tf), если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с [Dockerfile](https://github.com/Kovrei/app_diplom_mission3/blob/main/Dockerfile) тестового приложения и [ссылка на собранный docker image](https://hub.docker.com/repository/docker/rei169kov/nginx/general).
5. Репозиторий с конфигурацией Kubernetes кластера. [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)
6. Ссылка на [тестовое приложение](http://158.160.159.87/) и веб интерфейс [Grafana](http://158.160.159.87/monitor/) с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab). [структура](https://github.com/Kovrei/netology_diplom/tree/main/src) и [тест приложение](https://github.com/Kovrei/app_diplom_mission3) 

