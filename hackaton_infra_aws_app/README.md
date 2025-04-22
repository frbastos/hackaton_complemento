# Deploy to Amazon EKS

Este workflow utiliza **GitHub Actions** para automatizar o processo de atualização da infraestrutura no **Amazon EKS**.

---

## Pré-requisitos

- **AWS Account** com permissões para acessar o EKS.
- **DockerHub** para autenticação e pull de imagens.
- Configuração de **secrets** no repositório:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `DOCKERHUB_TOKEN`

---

## ⚙️ Estrutura do Workflow

O workflow realiza as seguintes etapas:

1. **Checkout do código**  
   Faz o download do código fonte do repositório.

2. **Configuração das credenciais AWS**  
   Configura as credenciais da AWS para acessar o cluster EKS.

3. **Atualização do Kubeconfig**  
   Atualiza o `kubeconfig` com as informações do cluster.

4. **Login no DockerHub**  
   Autentica no DockerHub para pull de imagens privadas, se necessário.

5. **Aplicação de ConfigMap e Secrets**  
   Aplica as configurações iniciais do Kubernetes.

6. **Deploy da aplicação**  
   Aplica o Deployment e Service YAML no cluster EKS.

---

## Trigger

O workflow é acionado nas seguintes situações:

- **Push** para a branch `main`
- **Pull Request** direcionado para a branch `main`

---

## Como usar

1. Garanta que os **secrets** estão configurados no repositório.  
2. Adicione os arquivos de configuração (YAML) na raiz do projeto.  
3. Faça **push** das alterações no repositório ou crie um **Pull Request**.  
4. O workflow será executado automaticamente.

---

## Estrutura dos arquivos

- **configmap.yaml**: Configurações da aplicação.
- **secrets.yaml**: Credenciais sensíveis.
- **app-deployment.yaml**: Deployment da aplicação.
- **app-svc.yaml**: Configuração do Service.

---

## Resultado esperado

Após a execução do workflow, a infraestrutura no cluster **Amazon EKS** será atualizada com sucesso.

---


## Subindo projeto

# config inicial
kubectl apply -f metrics.yaml
kubectl apply -f secrets.yaml
kubectl apply -f storage-class.yaml
kubectl apply -f storage-class-efs.yaml

# rabbitmq
kubectl apply -f rabbitmq/rabbitmq-pvc.yaml
kubectl apply -f rabbitmq/rabbitmq-srv.yaml
kubectl apply -f rabbitmq/rabbitmq-deployment.yaml 

# processador-video
kubectl apply -f processador-video/processador-video-pvc.yaml
kubectl apply -f processador-video/processador-video-configmap.yaml
kubectl apply -f processador-video/processador-video-srv.yaml
kubectl apply -f processador-video/processador-video-deployment.yaml

kubectl rollout restart deployment processador-deployment

# armazenamento-video
kubectl apply -f armazenamento-video/armazenamento-video-configmap.yaml
kubectl apply -f armazenamento-video/armazenamento-video-srv.yaml
kubectl apply -f armazenamento-video/armazenamento-video-deployment.yaml 

kubectl rollout restart deployment armazenamento-deployment

# Para poder criar o PVC

eksctl utils associate-iam-oidc-provider \
  --region=us-east-1 \
  --cluster=dev-fiap-eks-cluster \
  --approve

eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster dev-fiap-eks-cluster \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-name AmazonEKS_EBS_CSI_DriverRole

eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster dev-fiap-eks-cluster \
  --region us-east-1 \
  --service-account-role-arn arn:aws:iam::345594575392:role/AmazonEKS_EBS_CSI_DriverRole

kubectl get pods -n kube-system | grep ebs

# Rodar build com multiplataforma

docker buildx build --platform linux/amd64,linux/arm64 \
  -t ar989827/processador-video:latest \
  --push .

docker buildx build --platform linux/amd64,linux/arm64 \
  -t ar989827/armazenamento-video:latest \
  --push .

# Sistema de Arquivos EFS

## Criar Role EKS_EFS_CSI_DriverRole
aws iam create-role \
  --role-name AmazonEKS_EFS_CSI_DriverRole \
  --assume-role-policy-document file://trust-policy.json

## Anexar política necessária à role
aws iam attach-role-policy \
  --role-name AmazonEKS_EFS_CSI_DriverRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy


## Criar EFS
aws efs create-file-system \
  --region us-east-1 \
  --tags Key=Name,Value=efs-processador-video \
  --performance-mode generalPurpose

## Listar EFS Criado
aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --region us-east-1

## Instalar o EFS CSI DIVER
eksctl create addon \
  --name aws-efs-csi-driver \
  --cluster dev-fiap-eks-cluster \
  --region us-east-1 \
  --service-account-role-arn arn:aws:iam::345594575392:role/AmazonEKS_EFS_CSI_DriverRole \
  --force







