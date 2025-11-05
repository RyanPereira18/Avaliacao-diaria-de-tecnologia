import 'quiz_question_model.dart';

const List<QuizQuestion> questions = [
  // 1. Segurança
  QuizQuestion(
    questionText: 'O que é "Phishing"?',
    options: [
      'Um novo aplicativo de rede social.',
      'Uma técnica de golpe online para roubar dados pessoais.',
      'Um software para organizar arquivos.',
      'Um tipo de exercício físico para quem usa o PC.'
    ],
    correctOptionIndex: 1,
    explanation:
        'Phishing é um tipo de fraude online onde golpistas tentam "pescar" (fish) suas informações pessoais, como senhas e dados de cartão, fingindo ser uma empresa legítima.',
  ),
  // 2. Saúde Digital
  QuizQuestion(
    questionText:
        'Qual destes *não* é um sintoma comum do uso excessivo de telas antes de dormir?',
    options: [
      'Dificuldade para adormecer.',
      'Dores de cabeça frequentes.',
      'Aumento da disposição e energia pela manhã.',
      'Olhos secos ou irritados.'
    ],
    correctOptionIndex: 2,
    explanation:
        'A luz azul emitida por telas pode suprimir a melatonina (hormônio do sono), causando dificuldade para dormir e cansaço pela manhã, e não um aumento de disposição.',
  ),
  // 3. Produtividade
  QuizQuestion(
    questionText:
        'Qual prática é mais recomendada para manter o foco ao estudar usando o computador?',
    options: [
      'Deixar todas as notificações de redes sociais ativadas.',
      'Usar o "modo foco" do sistema ou apps que bloqueiam distrações.',
      'Assistir a uma série ao mesmo tempo (multitarefa).',
      'Fazer pausas apenas quando terminar todo o conteúdo.'
    ],
    correctOptionIndex: 1,
    explanation:
        'O "Modo Foco" é projetado especificamente para silenciar notificações e bloquear aplicativos que causam distração, ajudando a manter a concentração na tarefa principal.',
  ),
  // 4. Segurança
  QuizQuestion(
    questionText: 'O que é "Autenticação de Dois Fatores" (2FA)?',
    options: [
      'Usar duas senhas diferentes para o mesmo site.',
      'Uma camada extra de segurança que exige um código (além da senha).',
      'Um tipo de antivírus.',
      'Um login que expira em dois minutos.'
    ],
    correctOptionIndex: 1,
    explanation:
        'O 2FA adiciona uma segunda etapa de verificação (Fator 2), geralmente um código enviado para seu celular ou gerado por um app, tornando muito mais difícil para alguém invadir sua conta.',
  ),
  // 5. Rastro Digital
  QuizQuestion(
    questionText: 'O que é "Rastro Digital" (ou pegada digital)?',
    options: [
      'A marca de dedo que fica na tela do celular.',
      'O conjunto de dados que você deixa ao usar a internet.',
      'Um vírus que deixa o computador lento.',
      'O histórico do navegador que só você pode ver.'
    ],
    correctOptionIndex: 1,
    explanation:
        'Seu rastro digital é a soma de todas as suas atividades online, incluindo posts em redes sociais, histórico de buscas, curtidas e até dados de localização. Isso forma sua "identidade" online.',
  ),
  // 6. Produtividade
  QuizQuestion(
    questionText:
        'A "Técnica Pomodoro" é um método de gerenciamento de tempo que sugere:',
    options: [
      'Trabalhar por 2 horas seguidas e descansar 30 minutos.',
      'Estudar apenas ouvindo música clássica.',
      'Dividir o trabalho em blocos de 25 minutos com pausas curtas.',
      'Usar um cronômetro de tomate na mesa.'
    ],
    correctOptionIndex: 2,
    explanation:
        'A técnica clássica envolve 25 minutos de trabalho focado (um "pomodoro") seguidos por uma pausa de 5 minutos, ajudando a combater a fadiga mental.',
  ),
  // 7. Saúde Digital
  QuizQuestion(
    questionText: 'O que é "Ergonomia" no contexto do uso de tecnologia?',
    options: [
      'A velocidade da sua conexão com a internet.',
      'Um tipo de teclado para jogos.',
      'A ciência de projetar seu espaço de trabalho para ser seguro e confortável.',
      'Um software de economia de energia.'
    ],
    correctOptionIndex: 2,
    explanation:
        'Ergonomia é sobre adaptar seu ambiente (altura da cadeira, posição do monitor, tipo de mouse) ao seu corpo, para prevenir lesões e aumentar o conforto durante o uso.',
  ),
  // 8. Segurança
  QuizQuestion(
    questionText: 'Qual das seguintes é considerada a senha MAIS segura?',
    options: [
      'senha1234',
      'JoaoSilva1990',
      '12345678',
      'R\$t9!kZ@pQ_7f'
    ],
    correctOptionIndex: 3,
    explanation:
        'Uma senha segura é longa e complexa, misturando letras maiúsculas, minúsculas, números e símbolos. As outras opções são muito fáceis de adivinhar.',
  ),
  // 9. Digital Literacy
  QuizQuestion(
    questionText: 'O que é "Malware"?',
    options: [
      'Um termo geral para software malicioso (vírus, spyware, etc.).',
      'Qualquer software gratuito baixado da internet.',
      'Um componente físico do computador (hardware).',
      'Um aplicativo de mensagens criptografadas.'
    ],
    correctOptionIndex: 0,
    explanation:
        'Malware é a abreviação de "Malicious Software" (Software Malicioso). É um termo que engloba qualquer programa feito para danificar ou infiltrar-se em um sistema, como vírus, spyware, ransomware, etc.',
  ),
  // 10. Digital Literacy
  QuizQuestion(
    questionText:
        'Ao encontrar uma notícia online muito chocante, o que você deve fazer antes de compartilhar?',
    options: [
      'Compartilhar imediatamente para alertar a todos.',
      'Verificar a fonte e a data da notícia em sites confiáveis.',
      'Acreditar, se a pessoa que enviou for sua amiga.',
      'Apenas curtir, mas não compartilhar.'
    ],
    correctOptionIndex: 1,
    explanation:
        'Para combater a desinformação (fake news), é crucial sempre verificar a fonte, o autor e a data da notícia em veículos de imprensa confiáveis antes de acreditar ou compartilhar.',
  ),
];