# Enhanced xv6 Operating System

[![GitHub issue author](https://img.shields.io/badge/author-DaeIn%20Lee-blue.svg)](https://hconnect.hanyang.ac.kr/2014004893)

> **xv6** is a modern reimplementation of [Sixth Edition Unix](https://en.wikipedia.org/wiki/Version_6_Unix) in [ANSI C](https://en.wikipedia.org/wiki/ANSI_C) for [multiprocessor](https://en.wikipedia.org/wiki/Multiprocessing) [x86](https://en.wikipedia.org/wiki/X86) and [RISC-V](https://en.wikipedia.org/wiki/RISC-V) systems.

This repository contains projects for the 2018 Hanyang Univ. *Operating System Course* taught by Professor Jung, Hyung Soo.

If you find this repo helpful, please provide ![star](https://img.shields.io/github/stars/LazyRen/2018-Operating-Systems?style=social) to credit the author.

## Projects

* **[Project1: Unix Shell](./proj_shell)**<br>This project is to build basic user-level unix shell that can be used to run simple commands or batchfile.<br>Shell supports both interactive ![Shell](./proj_shell/assets/interactive.png)
* **[Project2: Scheduler](./proj_scheduler)**<br>This project implements MLFQ & stride scheduler for xv6 to choose the best candidate process.<br>![Blueprint](./proj_scheduler/assets/blueprint.png)
* **[Project3: Light Weight Process](./proj_LWP)**<br>This project implements LWP similar to pthread for xv6. Each LWP shares its address space, but have a separate stack for independent execution.<br>![PT2](./proj_LWP/assets/PT2.png)
* **[Project4: File System](./proj_FileSystem)**<br>Original xv6 file system only supports file with size of up to 70 KB. By implementing *triple indirect block addressing* into xv6's address system, modifyied xv6 now can support file as large as up to 1032 MB.![goal](./proj_FileSystem/assets/goal.png)
