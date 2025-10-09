# Ata de Configuração - Etapa 2

## Resumo do Projeto

Este documento registra o processo completo de configuração dos serviços de infraestrutura em instâncias EC2 da AWS ou On Premise, incluindo configurações de segurança, firewall e testes de conectividade para cada serviço implementado.

## Objetivo

Implementar uma infraestrutura completa com múltiplos serviços essenciais para um ambiente corporativo, garantindo segurança e funcionalidade adequadas.

## Membros do Grupo e Responsabilidades

### Gabriel dos Reis Nascimento - Servidor FTP (vsftpd)

**Status**: ✅ Concluído  
**Descrição**: Implementação de servidor FTP seguro para compartilhamento de arquivos com acesso controlado.

---

### [Nome do Membro] - AD com DNS e GPO

**Status**: ⏳ Pendente / ✅ Concluído  
**Descrição**: Configuração do Active Directory com serviços de DNS e implementação de Group Policy Objects.

---

### [Nome do Membro] - VPN (OpenVPN)

**Status**: ⏳ Pendente / ✅ Concluído  
**Descrição**: Configuração de servidor VPN utilizando OpenVPN para acesso remoto seguro.

---

### [Nome do Membro] - Servidor DHCP

**Status**: ⏳ Pendente / ✅ Concluído  
**Descrição**: Implementação de servidor DHCP para gerenciamento automático de endereços IP na rede.

---

### [Nome do Membro] - Servidor Web + Banco de Dados

**Status**: ⏳ Pendente / ✅ Concluído  
**Descrição**: Configuração de servidor web com banco de dados integrado para aplicações corporativas.

---

## Detalhamento das Implementações

### 📁 Servidor FTP (vsftpd) - Gabriel dos Reis Nascimento

#### Configuração do Servidor

##### 1. Acesso à VM

- Conectado à instância EC2 via SSH
- Sistema operacional: Ubuntu
- Usuário: ubuntu

##### 2. Instalação do vsftpd

```bash
sudo apt install vsftpd -y
```

##### 3. Verificação do Status do Serviço

```bash
sudo service vsftpd status
```

**Resultado**: Serviço instalado e rodando

##### 4. Configuração das Regras de Entrada (Inbound Rules) da EC2

- **Portas 20-21**: 0.0.0.0/0 (Custom TCP)
- **Portas 12000-12100**: 0.0.0.0/0 (Custom TCP)
- **Porta 22**: 0.0.0.0/0 (SSH)

##### 5. Configuração do Firewall UFW

```bash
sudo ufw allow 20:21/tcp
sudo ufw allow 12000:12100/tcp
sudo ufw allow 22/tcp
sudo ufw allow ssh
sudo ufw enable
```

**Status do Firewall**:

- Regras aplicadas com sucesso
- Firewall ativado e funcionando

##### 6. Criação de Usuário FTP

```bash
sudo useradd aluno
sudo passwd aluno
# Senha definida: aluno123
```

**Detalhes do usuário**:

- Nome: aluno
- Senha: aluno123
- Diretório home: /home/aluno

##### 7. Backup da Configuração Original

```bash
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bkp
```

**Arquivo de backup**: `/etc/vsftpd.conf.bkp`

##### 8. Configuração do vsftpd.conf

Adicionadas as seguintes configurações no arquivo `/etc/vsftpd.conf`:

```bash
userlist_deny=NO
userlist_file=/etc/vsftpd/user_list
tcp_wrappers=NO

# Caminho de compartilhamento
local_root=/home/aluno/dados
chroot_local_user=YES
allow_writeable_chroot=YES
```

**Explicação das configurações**:

- `userlist_deny=NO`: Permite acesso apenas aos usuários listados
- `userlist_file`: Arquivo contendo lista de usuários autorizados
- `local_root`: Diretório raiz para o usuário FTP
- `chroot_local_user=YES`: Restringe usuário ao diretório home
- `allow_writeable_chroot=YES`: Permite escrita no diretório restrito

##### 9. Criação do Arquivo de Lista de Usuários

```bash
sudo mkdir -p /etc/vsftpd
sudo vim /etc/vsftpd/user_list
```

**Conteúdo do arquivo**: `aluno`

##### 10. Configuração do Diretório de Compartilhamento

```bash
sudo mkdir -p /home/aluno/dados
sudo chown aluno /home/aluno/dados
cd /home/aluno/
ls -l
```

**Resultado**:

```bash
total 4
drwxr-xr-x 2 aluno root 4096 Oct  1 03:18 dados
```

##### 11. Reinicialização do Serviço

```bash
sudo service vsftpd restart
sudo service vsftpd status
```

**Status**: Serviço reiniciado com sucesso

##### 12. Teste Local

```bash
ftp aluno@localhost
```

**Resultado do teste**:

```bash
Connected to localhost.
220 (vsFTPd 3.0.5)
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
```

#### Testes de Conectividade Externa

##### 1. Configuração do Elastic IP

- **IP Público**: 35.170.162.90
- Associado à instância EC2 para acesso externo consistente

##### 2. Conexão SSH via Elastic IP

```bash
ssh -i "Eixo5_2025.2.pem" ubuntu@35.170.162.90
```

##### 3. Teste via FileZilla

- **Host**: 35.170.162.90
- **Usuário**: aluno
- **Senha**: aluno123
- **Porta**: 21 (padrão)
- **Modo**: Passivo (recomendado)

**Configurações importantes no FileZilla**:

- Marcar opção "Modo Passivo" para evitar problemas de firewall
- Usar modo binário para transferência de arquivos

##### Resultados Obtidos

##### ✅ Sucessos

1. Servidor FTP instalado e configurado com sucesso
2. Usuário criado com acesso restrito ao diretório `/home/aluno/dados`
3. Firewall configurado corretamente
4. Teste local bem-sucedido
5. Elastic IP configurado para acesso externo
6. Conexão externa via FileZilla funcionando

#### Conclusão do FTP

A configuração do servidor FTP foi concluída com sucesso, permitindo acesso seguro e controlado aos arquivos compartilhados. O sistema está operacional tanto para testes locais quanto para acesso externo via internet.

---

**Data**: Outubro 2024  
**Grupo**: Eixo 5 - LOGAM Tech
