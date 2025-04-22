
# FIAP K8S Infrastructure - Terraform Project

Este projeto configura a infraestrutura base para um RDS usando Terraform na AWS. Ele cria um RDS com um banco postgres.

---

## Pré-requisitos

Certifique-se de que os seguintes itens estão configurados antes de executar o projeto:

1. **Terraform**: Instalado na sua máquina.
2. **AWS CLI**: Instalado e configurado.
3. **Credenciais da AWS**: Configuradas via variáveis de ambiente ou arquivo de credenciais.

### Configurando as credenciais da AWS

Você pode configurar suas credenciais usando o AWS CLI:
```bash
aws configure
```

Ou definindo diretamente as variáveis de ambiente:
```bash
export AWS_ACCESS_KEY_ID="sua-access-key-id"
export AWS_SECRET_ACCESS_KEY="sua-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
```


## Comandos do Terraform

### **1. terraform init**
Inicializa o ambiente Terraform no diretório do projeto. Este comando:
- Baixa os provedores necessários, como o AWS Provider.
- Prepara o diretório `.terraform` para gerenciar o estado e plugins.

```bash
terraform init
```

---

### **2. terraform validate**
Valida a sintaxe e a configuração do Terraform. Este comando garante que não há erros no código antes de criar os recursos.

```bash
terraform validate
```

Se tudo estiver correto, a saída será:
```plaintext
Success! The configuration is valid.
```

---

### **3. terraform plan**
Gera um plano de execução, mostrando quais recursos serão criados, alterados ou destruídos. Este comando **não aplica as mudanças**, apenas mostra o que será feito.

```bash
terraform plan
```

Exemplo de saída:
```plaintext
Plan: 5 to add, 0 to change, 0 to destroy.
```

---

### **4. terraform apply**
Aplica o plano de execução e cria ou atualiza os recursos na AWS. O Terraform solicitará confirmação antes de executar.

```bash
terraform apply
```

Quando solicitado, digite `yes` para confirmar a aplicação.

Exemplo de saída ao final:
```plaintext
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

---

### **6. terraform destroy**
Remove todos os recursos criados pelo Terraform. O comando solicitará confirmação antes de destruir os recursos.

```bash
terraform destroy
```

Quando solicitado, digite `yes` para confirmar a destruição.

Exemplo de saída ao final:
```plaintext
Destroy complete! Resources: 5 destroyed.
```

---

## Fluxo Completo de Execução

Siga as etapas abaixo para configurar e executar o projeto:

1. **Inicializar o Terraform**
   ```bash
   terraform init
   ```

2. **Validar a configuração**
   ```bash
   terraform validate
   ```

3. **Gerar o plano**
   ```bash
   terraform plan
   ```

4. **Aplicar o plano**
   ```bash
   terraform apply
   ```

5. **Visualizar os Outputs**
   ```bash
   terraform output
   ```

6. **Destruir os recursos (opcional)**
   ```bash
   terraform destroy
   ```
