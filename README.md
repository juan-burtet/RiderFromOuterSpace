# PeC-IV-Jogos
## Repositório da Disciplina de Jogos (Ciência da Computação - UFPEL)

  * [Extras](https://github.com/juan-burtet/PeC-IV-Jogos/tree/master/Extras)
    > Pasta com arquivos extras pro Desenvolvimento do trabalho.
  * [Rider From Outer Space](https://github.com/juan-burtet/PeC-IV-Jogos/tree/master/Rider%20From%20Outer%20Space)
    > Repositório com o Projeto do Jogo.
  * [STORYBOARD.md](https://github.com/juan-burtet/PeC-IV-Jogos/blob/master/STORYBOARD.md)
    > Markdown contendo a Storyboard do Jogo __[Apresentado em aula]__.
  * [GAME.md](https://github.com/juan-burtet/PeC-IV-Jogos/blob/master/GAME.md)
    > Markdown contendo os tópicos do Storyboard atualizados com as artes usadas no jogo.

## Colisões dos Personagens
  * __Personagem[1]__: Toca em Inimigos, Mapa e Explosão
    * Layer: 1
    * Mask: 2 3 4
  * __Inimigos[2]__: Toca em Personagem, Mapa e Munição
    * Layer: 2
    * Mask: 1 3 5
  * __Mapa[3]__: Toca em Inimigos, Personagem e Munição
    * Layer: 3
    * Mask: 1 2 5
  * __Explosão[4]__: Toca em Personagem
    * Layer: 4
    * Mask: 1
  * __Munição[5]__: No Mapa e Inimigos
    * Layer: 5
    * Mask: 2 3
