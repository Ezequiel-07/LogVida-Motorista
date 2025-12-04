# Blueprint do Aplicativo de Rastreamento

## Visão Geral

Este documento descreve a arquitetura e os recursos de um aplicativo Flutter projetado para rastrear a localização do usuário em tempo real após a autenticação e notificá-lo.

## Recursos

*   **Autenticação de Usuário:** Tela de login simples usando e-mail e senha com Firebase Auth.
*   **Rastreamento de Localização em Tempo Real:** Após o login, o aplicativo rastreia a localização GPS do usuário.
*   **Armazenamento de Dados no Firestore:** As coordenadas de localização são enviadas para o Cloud Firestore a cada 10 segundos.
*   **Notificações Locais:** O usuário recebe notificações relacionadas ao status do rastreamento.

## Estrutura do Projeto

```
/lib
|-- /models
|   |-- user_location.dart
|-- /screens
|   |-- home_screen.dart
|   |-- login_screen.dart
|   |-- wrapper.dart
|-- /services
|   |-- auth_service.dart
|   |-- firestore_service.dart
|   |-- location_service.dart
|   |-- notification_service.dart
|-- main.dart
```

## Plano de Implementação Atual

1.  **Configurar o Firebase:** Inicializar o Firebase no projeto.
2.  **Adicionar Dependências:** Incluir `firebase_core`, `firebase_auth`, `cloud_firestore`, `location`, `flutter_local_notifications`, e `provider`.
3.  **Criar Arquivo `blueprint.md`:** Documentar o plano e a estrutura do projeto.
4.  **Inicializar o App e Serviços:** Modificar `main.dart` para inicializar os serviços necessários e configurar os provedores de estado.
5.  **Implementar a Autenticação:**
    *   Criar o `auth_service.dart` para gerenciar a lógica de login e estado do usuário.
    *   Desenvolver a `login_screen.dart` com campos para e-mail/senha.
    *   Criar um `wrapper.dart` para alternar entre a tela de login e a tela principal com base no estado de autenticação.
6.  **Desenvolver a Tela Principal (`home_screen.dart`):**
    *   Implementar a interface do usuário para a tela principal.
    *   Adicionar um botão de logout.
7.  **Implementar o Serviço de Localização:**
    *   Criar o `location_service.dart` para obter e transmitir atualizações de localização.
    *   Integrar o serviço na `home_screen.dart` para iniciar e parar o rastreamento.
8.  **Implementar o Serviço do Firestore:**
    *   Criar o `firestore_service.dart` para salvar os dados de localização.
    *   Usar um `Timer` na `home_screen.dart` para enviar a localização para o Firestore a cada 10 segundos.
9.  **Implementar Notificações:**
    *   Criar `notification_service.dart`.
    *   Mostrar notificações quando o rastreamento começar ou a localização for enviada.
10. **Formatação e Análise:** Executar `flutter format .` e `flutter analyze` para garantir a qualidade do código.

