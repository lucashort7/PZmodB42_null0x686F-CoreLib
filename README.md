# HortWiz Core

![Project Zomboid](https://img.shields.io/badge/Project%20Zomboid-B42-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Performance](https://img.shields.io/badge/Performance-O(1)-brightgreen)

Biblioteca compartilhada e zero-overhead para a suite de mods HortWiz. Não faz nenhuma mudança de gameplay sozinho — é uma dependência para os outros mods HortWiz.

## Features
- **Global Debug Panel:** UI centralizada (`HortWizDebugPanel`) com sidebar rail pra outros mods registrarem suas próprias abas via `_G.HortWizCore.registerTab(tabName, uiClass, category)`.
- **Logger Compartilhado:** `_G.HortWizCore.Log.new(mod_tag, level_getter)` / `.newFileLogger(mod_tag, level_getter, filename)` — logger leveled (`trace/debug/info/warn/error/fatal`) usado por todos os mods HortWiz, formato de saída consistente.
- **Tools:** `_G.HortWizCore.Tools.find_tool_by_tag(player, tags)` — utilitário pra achar a primeira ferramenta não-quebrada no inventário carregando uma tag específica.

## Instalação (Manual)
1. Baixe o último `.zip` da aba [Releases](../../releases).
2. Extraia a pasta `hortWiz_Core` dentro de `C:\Users\SEU_USUARIO\Zomboid\mods\`.
3. Ative o mod no menu principal do jogo.

## Quem depende disso
Este mod é uma dependência obrigatória (`require=hortWiz_Core` no `mod.info`) dos outros mods da suite HortWiz:
- HortWiz Context Cleaner
- HortWiz Combat Text
- HortWiz QoL V2

## Contribuição
Leia o [CONTRIBUTING.md](CONTRIBUTING.md) antes de enviar Pull Requests. Nós levamos a performance MUITO a sério. Qualquer código com *Vibe Coding* (loops desnecessários no render) será rejeitado.
