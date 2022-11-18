:- dynamic duda_possui/1.
:- dynamic local_duda/1.
:- dynamic dialogue/1.

local_duda(patio).

acessivel(patio, casa):- duda_possui(banho).
acessivel(patio, Y):- Y \== casa, Y\== escritorio.
acessivel(X, patio):- X \== escritorio.
acessivel(casa, escritorio).
acessivel(escritorio, casa).

trocar_local(X):- local_duda(Y), retract(local_duda(Y)), assert(local_duda(X)).

ir_para(X):- X\== patio, X\== casa, X\== lagoa, X\== galinheiro, X\== floresta, X\== escritorio, write("** Esse local não existe, tente outro.").
ir_para(X):- local_duda(Y), X == Y, write("** Duda já está em "), write(X).
ir_para(casa):- not(duda_possui(banho)), write("** Estou imunda de barro, não posso entrar na casa! Deve ter algum lugar onde possa me limpar").
ir_para(X):- local_duda(Y), not(acessivel(Y, X)), write("** Não consigo ir de "), write(Y), write(" para "), write(X).
ir_para(escritorio):- trocar_local(escritorio), mapa(escritorio), write("** Duda foi para escritorio"), nl, dialogue(escritorio).

ir_para(X):- trocar_local(X), mapa(X), nl, write("** Duda foi para "), write(X), nl.


pegar(X):- duda_possui(Y), X == Y, write("** Eu já tenho "), write(X).

pegar(banho):- local_duda(lagoa), assert(duda_possui(banho)), write("** Duda tomou banho!").
pegar(banho):- write("** Não posso tomar banho aqui.").

pegar(rede):- local_duda(casa), assert(duda_possui(rede)), write("** Duda pegou a rede.").
pegar(rede):- write("** A rede está na [casa].").

pegar(bessy):- duda_possui(rede), local_duda(floresta), assert(duda_possui(bessy)), mapa(floresta), write("** Duda pegou Bessy!").
pegar(bessy):- not(local_duda(floresta)), write("** Bessy está na [floresta].").
pegar(bessy):- not(duda_possui(rede)), write("** Preciso de uma rede para pegar Bessy, talvez tenha uma na [casa]!").

pegar(terno_pequeno):- local_duda(escritorio), assert(duda_possui(terno_pequeno)), write("** Duda pegou um terno pequeno").

pegar(_X):- write("** Esse item não existe!").


colocar(X, Y):- (X \== terno_pequeno; Y \== bessy), write("** Não é possível colocar "), write(X), write(" em "), write(Y).
colocar(terno_pequeno, bessy):- not(duda_possui(bessy)), write("** Não estou com a Bessy para fazer isso").
colocar(terno_pequeno, bessy):- not(duda_possui(terno_pequeno)), write("** Não tenho um terno pequeno para fazer isso").
colocar(terno_pequeno, bessy):- retract(duda_possui(bessy)), retract(duda_possui(terno_pequeno)), assert(duda_possui(bessy_de_terno)), write("** Você vestiu o terno pequeno na Bessy").


falar_com(bessy):- duda_possui(bessy), write("** Bessy: có có cocó").
falar_com(bessy):- local_duda(floresta), write("** Bessy: có có cocó").
falar_com(bessy):- write("-- Bessy não está aqui").

falar_com(homem_de_terno):- local_duda(escritorio), dialogue(homem_de_terno).
falar_com(homem_de_terno):- write("** Homem de terno não está aqui.").

falar_com(X):- write("** Não reconheço esse tal "), write(X).


finalizado:- duda_possui(bessy), local_duda(galinheiro),  write("** Obrigado por salvar Bessy!!!!!!!!!"), nl.
finalizado:- duda_possui(bessy_de_terno), local_duda(escritorio),  dialogue(homem_de_terno), write("** Na segunda, Homem de Terno leva Bessy para o escritório e ela consegue um emprego, em poucos anos Bessy sobe a escada corporativa e se torna CEO da empresa. Bessy vive feliz."), nl.

rodar:- dialogue(sim), dialogue(menu_principal), mapa(patio), retract(dialogue(sim)), rodar.
rodar:- finalizado, nl, write("Jogo finalizado").
rodar:- nl, write("Digite o que deseja fazer:"), nl, write(">> "), read(X), call(X), rodar.

dialogue(sim).
dialogue(menu_principal):- write("FUGA DA GALINHA"), nl,
               write("              ..       "), nl,
               write("        ____ / '>      "), nl,
               write("        >-_- )  )      "), nl,
               write("       .( ,,.,./.      "), nl,
               write("       '', '.-','      "), nl,
               write("A Dona Lurdes te chamou para capturar Bessy, a galinha premiada que fugiu para a floresta!"), nl,
               write("Você consegue leva-la de volta para o galinheiro???"), nl,
               nl, write("-----COMANDOS-----"), nl,
               write("ir_para(X) - Vai pro lugar indicado entre os parenteses"), nl,
               write("pegar(X) - Pega o item indicado entre os parenteses"), nl,
               write("colocar(X, Y) - Coloca X em Y"), nl,
               write("falar_com(X) - Fala com a pessoa especificada entre os parenteses"), nl,
               nl, write("-----LOCAIS-----"), nl,
               write("patio "), nl, write("floresta "), nl, write("lagoa "), nl, write("casa "), nl, write("galinheiro "), nl, write("escritorio "), nl.

dialogue(escritorio):- (duda_possui(bessy_de_terno) ; (duda_possui(bessy) , duda_possui(terno_pequeno))), write("** Você entra no pequeno escritorio da casa e vê um [homem_de_terno]"), nl.
dialogue(escritorio):- duda_possui(bessy), write("** Você entra no pequeno escritorio da casa e vê um [homem_de_terno] e um [terno_pequeno] em cima da cama"), nl.
dialogue(escritorio):- duda_possui(terno_pequeno), write("** Você entra no pequeno escritorio da casa e vê um [homem_de_terno] triste"), nl.
dialogue(escritorio):- write("** Você entra no pequeno escritorio da casa e vê um [homem_de_terno] triste e um [terno_pequeno] em cima da cama"), nl.


dialogue(homem_de_terno):- duda_possui(bessy), write("** Homem de Terno: Obrigado por resgatar a Bessy! :)") ,nl.
dialogue(homem_de_terno):- duda_possui(bessy_de_terno), nl, write("** Homem de Terno: A Bessy de terno? Como não pensei nisso antes? Vou levar ela para o escritório da minha empresa na cidade."), nl.
dialogue(homem_de_terno):- write("** Homem de Terno: Não consigo concentrar no trabalho sabendo que a minha galinha fugiu :("), nl.


mapa(patio):- (duda_possui(bessy); duda_possui(bessy_de_terno)),
              write(" _____________________ "), nl,
              write("| ´´     T      ´ ´´  |"), nl,
              write("|T ´ ´ T    ´ ´´   T  |"), nl,
              write("|   T  ´  T     T  `  |"), nl,
              write("| T         T `` T____|"), nl,
              write("| `   ´ ´´  _  ` /____|"), nl,
              write("| ____ `´ _| |_  |_[] |"), nl,
              write("||~~~~| _|.  ..|___|| |"), nl,
              write("||~~~~||_ ; D; |---|| |"), nl,
              write("| |~~~|  |_,__:|  //|_|"), nl,
              write("|  ---            |[]_|"), nl,
              write(" --------------------- "), nl.
mapa(patio):- write(" _____________________ "), nl,
              write("| ´´     T      ´ ´´  |"), nl,
              write("|T ´ ´ T    ´ ´´   T  |"), nl,
              write("|   T  b  T     T  `  |"), nl,
              write("| T         T `` T____|"), nl,
              write("| `   ´ ´´  _  ` /____|"), nl,
              write("| ____ `´ _| |_  |_[] |"), nl,
              write("||~~~~| _|.  ..|___|| |"), nl,
              write("||~~~~||_ ; D; |---|| |"), nl,
              write("| |~~~|  |_,__:|  //|_|"), nl,
              write("|  ---            |[]_|"), nl,
              write(" --------------------- "), nl.



mapa(lagoa):- (duda_possui(bessy); duda_possui(bessy_de_terno)),
              write(" _____________________ "), nl,
              write("| ´´     T      ´ ´´  |"), nl,
              write("|T ´ ´ T    ´ ´´   T  |"), nl,
              write("|   T  ´  T     T  `  |"), nl,
              write("| T         T `` T____|"), nl,
              write("| `   ´ ´´  _  ` /____|"), nl,
              write("| ____ `´ _| |_  |_[] |"), nl,
              write("||~~~~| _|.  ..|___|| |"), nl,
              write("||~~D~||_ ; .; |---|| |"), nl,
              write("| |~~~|  |_,__:|  //|_|"), nl,
              write("|  ---            |[]_|"), nl,
              write(" --------------------- "), nl.

mapa(lagoa):- write(" _____________________ "), nl,
              write("| ´´     T      ´ ´´  |"), nl,
              write("|T ´ ´ T    ´ ´´   T  |"), nl,
              write("|   T  b  T     T  `  |"), nl,
              write("| T         T `` T____|"), nl,
              write("| `   ´ ´´  _  ` /____|"), nl,
              write("| ____ `´ _| |_  |_[] |"), nl,
              write("||~~~~| _|.  ..|___|| |"), nl,
              write("||~~D~||_ ; .; |---|| |"), nl,
              write("| |~~~|  |_,__:|  //|_|"), nl,
              write("|  ---            |[]_|"), nl,
              write(" --------------------- "), nl.


mapa(floresta):- (duda_possui(bessy); duda_possui(bessy_de_terno)),
                 write(" _____________________ "), nl,
                 write("| ´´     T      ´ ´´  |"), nl,
                 write("|T ´ ´ T    ´ ´´   T  |"), nl,
                 write("|   T  ´  T     T  `  |"), nl,
                 write("| T     D   T `` T____|"), nl,
                 write("| `   ´ ´´  _  ` /____|"), nl,
                 write("| ____ `´ _| |_  |_[] |"), nl,
                 write("||~~~~| _|.  ..|___|| |"), nl,
                 write("||~~~~||_ ; .; |---|| |"), nl,
                 write("| |~~~|  |_,__:|  //|_|"), nl,
                 write("|  ---            |[]_|"), nl,
                 write(" --------------------- "), nl.

mapa(floresta):- write(" _____________________ "), nl,
                 write("| ´´     T      ´ ´´  |"), nl,
                 write("|T ´ ´ T    ´ ´´   T  |"), nl,
                 write("|   T  b  T     T  `  |"), nl,
                 write("| T     D   T `` T____|"), nl,
                 write("| `   ´ ´´  _  ` /____|"), nl,
                 write("| ____ `´ _| |_  |_[] |"), nl,
                 write("||~~~~| _|.  ..|___|| |"), nl,
                 write("||~~~~||_ ; .; |---|| |"), nl,
                 write("| |~~~|  |_,__:|  //|_|"), nl,
                 write("|  ---            |[]_|"), nl,
                 write(" --------------------- "), nl.


mapa(casa):- (duda_possui(bessy); duda_possui(bessy_de_terno)),
             write(" _____________________ "), nl,
             write("| ´´     T      ´ ´´  |"), nl,
             write("|T ´ ´ T    ´ ´´   T  |"), nl,
             write("|   T  ´  T     T  `  |"), nl,
             write("| T         T `` T____|"), nl,
             write("| `   ´ ´´  _  ` /____|"), nl,
             write("| ____ `´ _| |_  |_[D]|"), nl,
             write("||~~~~| _|.  ..|___|| |"), nl,
             write("||~~~~||_ ; .; |---|| |"), nl,
             write("| |~~~|  |_,__:|  //|_|"), nl,
             write("|  ---            |[]_|"), nl,
             write(" --------------------- "), nl.

mapa(casa):- write(" _____________________ "), nl,
             write("| ´´     T      ´ ´´  |"), nl,
             write("|T ´ ´ T    ´ ´´   T  |"), nl,
             write("|   T  b  T     T  `  |"), nl,
             write("| T         T `` T____|"), nl,
             write("| `   ´ ´´  _  ` /____|"), nl,
             write("| ____ `´ _| |_  |_[D]|"), nl,
             write("||~~~~| _|.  ..|___|| |"), nl,
             write("||~~~~||_ ; .; |---|| |"), nl,
             write("| |~~~|  |_,__:|  //|_|"), nl,
             write("|  ---            |[]_|"), nl,
             write(" --------------------- "), nl.


mapa(galinheiro):- (duda_possui(bessy); duda_possui(bessy_de_terno)),
                   write(" _____________________ "), nl,
                   write("| ´´     T      ´ ´´  |"), nl,
                   write("|T ´ ´ T    ´ ´´   T  |"), nl,
                   write("|   T  ´  T     T  `  |"), nl,
                   write("| T         T `` T____|"), nl,
                   write("| `   ´ ´´  _  ` /____|"), nl,
                   write("| ____ `´ _| |_  |_[] |"), nl,
                   write("||~~~~| _|.  ..|___|| |"), nl,
                   write("||~~~~||_ ; .; |---|| |"), nl,
                   write("| |~~~|  |_,__:|  //|_|"), nl,
                   write("|  ---            |D]_|"), nl,
                   write(" --------------------- "), nl.

mapa(galinheiro):- write(" _____________________ "), nl,
                   write("| ´´     T      ´ ´´  |"), nl,
                   write("|T ´ ´ T    ´ ´´   T  |"), nl,
                   write("|   T  b  T     T  `  |"), nl,
                   write("| T         T `` T____|"), nl,
                   write("| `   ´ ´´  _  ` /____|"), nl,
                   write("| ____ `´ _| |_  |_[] |"), nl,
                   write("||~~~~| _|.  ..|___|| |"), nl,
                   write("||~~~~||_ ; .; |---|| |"), nl,
                   write("| |~~~|  |_,__:|  //|_|"), nl,
                   write("|  ---            |D]_|"), nl,
                   write(" --------------------- "), nl.


mapa(escritorio):- (duda_possui(bessy); duda_possui(bessy_de_terno)),
                   write(" _____________________ "), nl,
                   write("| ´´     T      ´ ´´  |"), nl,
                   write("|T ´ ´ T    ´ ´´   T  |"), nl,
                   write("|   T  ´  T     T  `  |"), nl,
                   write("| T         T `` T____|"), nl,
                   write("| `   ´ ´´  _  ` /_D__|"), nl,
                   write("| ____ `´ _| |_  |_[] |"), nl,
                   write("||~~~~| _|.  ..|___|| |"), nl,
                   write("||~~~~||_ ; .; |---|| |"), nl,
                   write("| |~~~|  |_,__:|  //|_|"), nl,
                   write("|  ---            |[]_|"), nl,
                   write(" --------------------- "), nl.

mapa(escritorio):- write(" _____________________ "), nl,
                   write("| ´´     T      ´ ´´  |"), nl,
                   write("|T ´ ´ T    ´ ´´   T  |"), nl,
                   write("|   T  b  T     T  `  |"), nl,
                   write("| T         T `` T____|"), nl,
                   write("| `   ´ ´´  _  ` /_D__|"), nl,
                   write("| ____ `´ _| |_  |_[] |"), nl,
                   write("||~~~~| _|.  ..|___|| |"), nl,
                   write("||~~~~||_ ; .; |---|| |"), nl,
                   write("| |~~~|  |_,__:|  //|_|"), nl,
                   write("|  ---            |[]_|"), nl,
                   write(" --------------------- "), nl.








