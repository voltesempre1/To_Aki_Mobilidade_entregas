# Análise Detalhada do Sistema de Pagamentos - Tô Aki Mobilidade

Baseado na análise dos três projetos (customer, driver, admin), aqui está o fluxo completo de pagamentos do sistema:

## **1. ESTRUTURA GERAL DO SISTEMA**

O sistema possui três aplicações Flutter distintas:

- **Customer**: App do cliente que solicita viagens
- **Driver**: App do motorista que presta o serviço
- **Admin**: Painel administrativo web para gerenciar o sistema

## **2. GATEWAYS DE PAGAMENTO SUPORTADOS**

O sistema suporta múltiplos métodos de pagamento:

**Gateways Online:**

- **Stripe** - Pagamentos com cartão internacional
- **PayPal** - Pagamentos via PayPal
- **Razorpay** - Gateway indiano
- **PayStack** - Gateway africano
- **MercadoPago** - Gateway latino-americano
- **PayFast** - Gateway sul-africano
- **FlutterWave** - Gateway multi-regional

**Métodos Locais:**

- **Cash** - Pagamento em dinheiro
- **Wallet** - Carteira digital interna

## **3. FLUXO DE PAGAMENTO DO CLIENTE**

### **3.1. Pagamento de Viagem**

1. Cliente seleciona origem e destino
2. Sistema calcula preço baseado em:
   - Distância
   - Tarifas configuradas
   - Taxas administrativas
   - Comissões
3. Cliente escolhe método de pagamento
4. Para pagamentos online:
   - Redirecionamento para gateway
   - Processamento seguro
   - Callback de confirmação
5. Valor é debitado do cliente

### **3.2. Recarga de Carteira (Wallet)**

- Cliente pode adicionar créditos na carteira
- Suporta todos os gateways configurados
- Valores ficam disponíveis para viagens futuras
- Histórico de transações é mantido

## **4. SISTEMA DE CARTEIRA E GANHOS DO MOTORISTA**

### **4.1. Recebimento de Pagamentos**

- Motoristas possuem carteira digital (`walletAmount`)
- Valores das corridas são creditados automaticamente
- Sistema de comissões descontado:

  ```dart
  // Exemplo de estrutura de ganhos
  totalEarning: valor_total_bruto
  walletAmount: valor_disponível_após_comissões
  ```

### **4.2. Saque de Valores**

O motorista pode sacar via sistema bancário:

**Processo de Saque:**

1. Motorista solicita saque no app
2. Informa valor e seleciona conta bancária cadastrada
3. Pedido vai para admin com status "Pending"
4. Admin aprova/rejeita no painel
5. Status atualizado: "Complete" ou "Rejected"

**Dados Bancários Required:**

```dart
// Estrutura dos dados bancários
BankDetailsModel {
  bankName: string
  accountNumber: string
  holderName: string
}
```

## **5. CONFIGURAÇÕES ADMINISTRATIVAS**

### **5.1. Configuração de Gateways**

O admin configura cada gateway com:

- Chaves de API (pública/secreta)
- URLs de callback
- Modo sandbox/produção
- Status ativo/inativo

**Exemplo - Stripe:**

```dart
Strip {
  clientPublishableKey: "pk_test_..."
  stripeSecret: "sk_test_..."
  isActive: true
  isSandbox: true
}
```

### **5.2. Gestão de Saques**

- Visualização de todas as solicitações
- Filtros por status, data, motorista
- Aprovação/rejeição com notas
- Exportação de relatórios Excel

## **6. ARQUITETURA DE PAGAMENTOS**

### **6.1. Fluxo de Dados**

```
Cliente → Gateway → Firestore → Driver Wallet
                ↘ Admin Dashboard (monitoramento)
```

### **6.2. Segurança**

- Chaves de API protegidas no Firebase
- Callbacks URLs validadas
- Transações logadas com `TransactionLogModel`
- Histórico completo mantido

### **6.3. URLs de Callback**

Sistema usa URLs padronizadas:

```dart
"${Constant.paymentCallbackURL}/success"
"${Constant.paymentCallbackURL}/failure"
"${Constant.paymentCallbackURL}/pending"
```

## **7. MODELOS DE COMISSÃO**

O sistema implementa comissões através de:

- `AdminCommission` - Porcentagem para a plataforma
- Descontos automáticos nos ganhos do motorista
- Transparência no cálculo de valores

## **8. RELATÓRIOS E CONTROLE**

### **8.1. Dashboards**

- **Admin**: Visão geral de transações, saques, receitas
- **Driver**: Histórico de ganhos, saldo, saques
- **Customer**: Histórico de gastos, recargas de carteira

### **8.2. Auditoria**

- Todas as transações são logadas
- Timestamps de criação/pagamento
- IDs únicos para rastreamento
- Integração com sistemas externos via APIs

## **9. CONSIDERAÇÕES TÉCNICAS**

- **Firebase/Firestore**: Banco de dados principal
- **Estado Reativo**: GetX para gerenciamento
- **WebViews**: Para integração com gateways
- **Validações**: Múltiplas camadas de segurança
- **Internacionalização**: Suporte a múltiplas moedas

## **10. ARQUIVOS RELEVANTES ANALISADOS**

### **Customer App:**

- `lib/app/models/payment_method_model.dart` - Modelos de pagamento
- `lib/app/modules/payment_method/` - Seleção de métodos
- `lib/payments/` - Implementações dos gateways
- `lib/app/modules/my_wallet/` - Gestão de carteira

### **Driver App:**

- `lib/app/modules/my_wallet/controllers/my_wallet_controller.dart` - Controle de carteira
- `lib/app/modules/my_wallet/views/widgets/withdrawal_dialog_view.dart` - Interface de saque
- `lib/payments/` - Gateways para recarga

### **Admin Panel:**

- `lib/app/modules/payment/controllers/payment_controller.dart` - Configuração de gateways
- `lib/app/modules/payout_request/controllers/payout_request_controller.dart` - Gestão de saques

Este sistema oferece um ecossistema completo de pagamentos com flexibilidade para diferentes regiões e métodos de pagamento, controle administrativo robusto e transparência para todos os stakeholders.
