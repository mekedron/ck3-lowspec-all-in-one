# All-in-One Map Pack Without Advanced Shaders (CK3)

Четыре мода карты для игры с выключенной графической опцией **Advanced Shaders** —
одним модом вместо четырёх:

* [Sharp Terrain Without Advanced Shaders](https://github.com/mekedron/ck3-lowspec-terrain-fix) —
  текстуры земли в полном разрешении вместо размытой «акварели» low spec
* [Real Snow Without Advanced Shaders](https://github.com/mekedron/ck3-lowspec-real-snow) —
  материал снега из high spec вместо плоских пятен
* [Better Water Without Advanced Shaders](https://github.com/mekedron/ck3-lowspec-water) —
  анимированные волны, блик солнца и отражение неба на море и озёрах
* [Smooth Zoom Transitions](https://github.com/mekedron/ck3-zoom-transition-fix) —
  два фриза при зуме разнесены по соседним шагам зума

Для ванильной карты. Это те же файлы, что и в четырёх модах с включённым Real Snow,
поэтому выглядит и стоит ровно столько же, сколько такой плейсет. Отдельные моды
остаются, и они — правильный выбор для тех, кому нужны не все четыре.

**Гайд:** [CK3 on a potato PC: a locked 60 FPS, and the map still looks sharp](https://steamcommunity.com/sharedfiles/filedetails/?id=3800254441) —
полный список настроек, под которые сделаны эти моды.

<img src="thumbnail.png" alt="Превью четырёх модов сеткой 2x2" width="360">

## Почему вообще четыре мода

Движок компилирует шейдеры с фиксированным набором define'ов, которые задают
собственные графические настройки игры, и мод не может добавить в меню настроек пункт,
который дошёл бы до компилятора шейдеров. Возможность, которая должна быть
опциональной, — настоящий снег стоит несколько миллисекунд зимой, — можно сделать
опциональной только отдельным модом. Поэтому Real Snow — аддон из одного файла,
включающий опцию в Sharp Terrain, Better Water самостоятелен, а Smooth Zoom вообще не
трогает шейдеры. Этот пак — для тех, кому всё равно нужно всё.

## Состав

Каждый файл — побайтовая копия из одного из четырёх репозиториев; здесь ничего не
правится.

    gfx/FX/pdxterrain.shader                    Sharp Terrain
    gfx/FX/lowspec_disease.fxh                  Sharp Terrain (хук эпидемий, пустой)
    gfx/FX/sharp_terrain_options.fxh            Real Snow (опция снега включена)
    gfx/FX/pdxwater.shader                      Better Water
    gfx/FX/jomini/jomini_water_default.fxh      Better Water
    gfx/FX/better_water_options.fxh             Better Water
    gfx/map/map_object_data/*.txt               Smooth Zoom Transitions
    common/defines/graphic/zz_smooth_zoom_*     Smooth Zoom Transitions

Ни один из четырёх модов не пишет файл, который пишет другой, кроме
`sharp_terrain_options.fxh` — ради его замены Real Snow и существует. Описание каждого
изменения, его цены и компромиссов — в исходных репозиториях.

## Как пользоваться

* Включай его **вместо** четырёх отдельных модов, а не вместе с ними. Если в плейсете
  есть и то и другое, побеждает нижняя копия каждого файла, а после обновления одной
  из сторон это смесь двух версий.
* Advanced Shaders держи **выключенными**. Если они включены, шейдерная часть ничего не
  делает; Smooth Zoom работает в обоих режимах.
* Опции: материал снега и обе опции воды включены. Чтобы поменять, отредактируй
  `gfx/FX/sharp_terrain_options.fxh` или `gfx/FX/better_water_options.fxh` в
  установленной копии. Файл дальности названий для ультрашироких экранов из Smooth Zoom
  лежит выключенным как `zz_smooth_zoom_05_ultrawide.txt.off`; переименуй в `.txt`,
  чтобы включить.
* [Visible Epidemics Without Advanced Shaders](https://github.com/mekedron/ck3-lowspec-epidemics)
  работает с паком так же, как с Sharp Terrain: ставь его **ниже** пака.
* Не для **A Game of Thrones**. Для AGOT нужны отдельные моды и их AGOT-патчи, которые
  собраны поверх отдельных модов.

## Структура

    descriptor.mod                  метаданные мода
    thumbnail.png                   превью для Workshop, должно лежать в корне мода
    gfx/, common/                   сам мод, генерируется tools/sync.sh
    install.sh                      копирует мод в Proton-префикс
    tools/sync.sh                   пересобирает gfx/ и common/ из четырёх репозиториев
    tools/check_log.sh              проверка монтирования и ошибок шейдеров после запуска
    tools/bbcode_to_plain.py        тексты для Paradox Mods из текстов для Steam
    steam-workshop/                 тексты страницы и генератор превью

## Обновление

Четыре репозитория должны лежать рядом с этим. После релиза любого из них:

    tools/sync.sh

Скрипт откажется работать, если два источника когда-нибудь положат один и тот же путь
(кроме файла опций снега), и печатает коммит и версию каждого источника — их стоит
указать в сообщении релизного коммита. Затем подними `version` в `descriptor.mod`,
перезапусти `install.sh` и загрузи из лаунчера.

## Установка

Запусти `./install.sh`. Он копирует мод в папку модов CK3 внутри Proton-префикса.
Затем включи его в плейсете лаунчера и выключи четыре отдельных мода. Первая загрузка
карты дольше — шейдеры перекомпилируются.

## Версия игры

Собран под 1.20.0.2 (Crozier) из Sharp Terrain 2.0.0, Real Snow 1.2.0, Better Water
2.0.0 и Smooth Zoom Transitions 1.1.0.

## Мультиплеер / достижения

Только графика: игровые, скриптовые и исторические файлы не меняются, так что
ironman и достижения не затронуты, а мод можно добавить или убрать посреди кампании.
