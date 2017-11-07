# libpluie-echo

small vala shared library managing tracing, display formatting and ansi-extended colors on stdout & stderror.


## Prerequisites

valac meson ninja glib gobject


## Install

git clone the project then cd to project and do :

```
meson --prefix=/usr ./ build
sudo ninja install -C build
```

## Compilation

```
valac --pkg pluie-echo-0.1  main.vala -o echo
```

## Docker

a demo image is available on docker hub. you can run a container with :

```
docker run --rm -it pluie/libecho
```

## Usage

#### playing with colors
```
using Pluie;

int main (string[] args)
{
    var c1 = new Color(37, false);
    var c2 = new Color(204, true);
    stdout.printf ("[%s][%s]", c1.s ("oki"), c2.s ("cool"));
    return 0;
}
```

#### playing with ColorConf

compile main.vala
```
valac --pkg pluie-echo-0.1  main.vala -o echo
```

run ./echo

![ColorConf 1 code](https://www.meta-tech.academy/img/libpluie-echo_sample_colorconf1.png)

then, change in resources/echo.ini :  
```
title      =  15,1,97
title_item = 220,1
title_sep  =  97,1
```

run echo again :

![ColorConf 2 code](https://www.meta-tech.academy/img/libpluie-echo_sample_colorconf2.png)


#### init OutputFormatter
```
using GLib;
using Pluie;

int main (string[] args)
{
    var of = Echo.init (true /* enable tracing */, "resources/echo.ini" /* optional config file */);
    Dbg.in (Log.METHOD);
    
    of.echo (
        // multiline string
        "\nsample echo\non multiple\nline", 
        // newline
        true,
        // indent all line
        true,
        // set color with Pluie.ECHO enum (listing all defined styles in echo.ini)
        ECHO.ACTION
    );
    ...

    Dbg.out (Log.METHOD);
    return 0;
}
```

#### more samples

![Sample 1 code](https://www.meta-tech.academy/img/libpluie-echo_sample_code1.png?tmp=1)
![Sample 1 output](https://www.meta-tech.academy/img/libpluie-echo_sample1.png?tmp=1)
![Sample 2 code](https://www.meta-tech.academy/img/libpluie-echo_sample_code2.png?tmp=1)
![Sample 2 output](https://www.meta-tech.academy/img/libpluie-echo_sample2.png?tmp=1)


## Configuration

configuration file is installed by default on {prefix}/share/pluie/echo.ini

```
[Term]
term_width = 105
indent     = 4
key_maxlen = 17

[Colors]
# keys are fixed. overwrite only values
# fg ansi extended color code (0..255), bold (0|1), bg ansi extended color code (0..255)
default    =
comment    = 103,1
option     =  37,1
option_sep = 158
arg        =  97,1
arg_sep    = 147,1
title      =  15,1,24
title_item = 220,1
title_sep  =  24,1
section    =  37
sep        =  59
item       = 215,1
action     =  97,1
done       =  15,1,36
fail       =  15,1,196
key        =  37,1
val        = 215,1
date       = 215,1
time       = 210,1
microtime  = 204,1
file       =  95,1
num        = 218,1
enter      =  36,1
leave      = 167,1
warn       = 220,1,89
error      =  15,1,196
```
