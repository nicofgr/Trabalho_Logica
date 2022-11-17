:- dynamic duda_possui/1.
:- dynamic local_duda/1.
:- dynamic menu_inicial/1.

local_duda(patio).
menu_inicial(sim).

acessivel(patio, casa):- duda_possui(banho).
acessivel(patio, Y):- Y \== casa.
acessivel(X, Y):- X = patio; Y = patio.

ir_para(X):- X\== patio, X\== casa, X\== lagoa, X\== galinheiro, X\== floresta, write("Esse local não existe, tente outro.").
ir_para(X):- local_duda(Y), X == Y, write("Duda já está em "), write(X).
ir_para(X):- X = casa, not(duda_possui(banho)), write("Estou imunda de barro, não posso entrar na casa! Deve ter algum lugar onde possa me limpar").
ir_para(X):- local_duda(Y), not(acessivel(Y, X)), write("Não consigo ir de "), write(Y), write(" para "), write(X).
ir_para(X):- retract(local_duda(Y)), assert(local_duda(X)), write("Duda foi para "), write(X).


pegar(X):- duda_possui(Y), X == Y, write("Eu já tenho "), write(X).

pegar(X):- X = banho, local_duda(Y), Y = lagoa, assert(duda_possui(banho)), write("Duda tomou banho!").
pegar(X):- X = banho, write("Não posso tomar banho aqui.").

pegar(X):- X = rede, local_duda(Y), Y = casa, assert(duda_possui(rede)), write("Duda pegou a rede.").
pegar(X):- X = rede, write("A rede está na casa.").

pegar(X):- X = bessy, duda_possui(W), W = rede, local_duda(Y), Y = floresta, assert(duda_possui(bessy)), write("Duda pegou Bessy!").
pegar(X):- X = bessy, duda_possui(W), W = rede, write("Preciso de uma rede para pegar Bessy, talvez tenha uma na [casa]!").
pegar(X):- X = bessy, write("Bessy está na [floresta].").

pegar(X):- write("Esse item não existe!").

menu_inicial:- write("FUGA DA GALINHA"), nl,
               write("A Dona Lurdes te chamou para capturar Bessy, a galinha premiada que fugiu para a floresta!"), nl,
               write("Você consegue leva-la de volta para o galinheiro???"), nl,
               nl, write("-----COMANDOS-----"), nl,
               write("ir_para() - Vai pro lugar indicado entre os parenteses"), nl,
               write("pegar() - Pega o item indicado entre os parenteses"), nl,
               nl, write("-----LOCAIS-----"), nl,
               write("patio "), nl, write("floresta "), nl, write("lagoa "), nl, write("casa "), nl, write("galinheiro "), nl.


finalizado:- duda_possui(bessy), local_duda(galinheiro).

rodar:- menu_inicial(sim), menu_inicial, retract(menu_inicial(sim)), rodar.
rodar:- finalizado, write("Você salvou Bessy!!!!!!!!! Jogo finalizado").
rodar:- nl, write("Digite o que deseja fazer:"), nl, write(">> "), read(X), call(X), rodar.

