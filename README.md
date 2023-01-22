# Characterizing Sporadic Groups by their Codegree Sets

This README.md file contains basic information about this project and instructions on how to edit and/or and run the project.

## Table of Contents
1. Description

1. Requirements

1. Installation

1. Usage

1. Contributions

1. License

## Description

The files contained in this repository were used to assist in the proving the theorem that that the simple sporadic groups are determined up to isomorphism by their codegree sets. The theorem appears in the article "On the Characterization of Sporadic Simple Groups by Codegrees" which has the following abstract

 >Let $G$ be a finite group and $\mathrm{Irr}(G)$ the set of all irreducible complex characters of $G$.  Define the codegree of $\chi \in \mathrm{Irr}(G)$ as $\mathrm{cod}(\chi):=\frac{|G:\mathrm{ker}(\chi) |}{\chi(1)}$ and denote by $\mathrm{cod}(G):=\{\mathrm{cod}(\chi) \mid \chi\in \mathrm{Irr}(G)\}$ the codegree set of $G$. Let $H$ be one of the $26$ sporadic simple groups. In this paper, we show that $H$ is determined up to isomorphism by $\mathrm{cod}(H)$.

 The proof of the theorem is completed in two main parts, which are separated in the paper. The first part involves proving that if a group $G$ has the same codegree set as a sporadic simple group $H$, then if $N$ is a maximal normal subgroup of $G$, then $G/N \cong H$. The second part of the proof involves showing that $N = 1$, and hence $G \cong H$. Please reach out to the contributors for more information if interested.

## Requirements

This project assumes you have [Julia](https://julialang.org/) downloaded and installed on your local machine. Visit the downloads page [here](https://julialang.org/downloads/) to find the latest release for Windows, macOS, or Linux. You can confirm that Julia was correctly installed on your machine and is accesible globally by simply running the command `julia` on any terminal. If you believe Julia is installed correctly but that is not working, it is likely that your path variable was not set up correctly. 

## Installation 

Clone this repository to your local machine and navigate to the root of the cloned repository.

## Usage

Once all dependencies are downloaded and installed, you can run Julia scripts with the command `julia <filename>`. Specifically, run the scripts written for this research project with the below commands.

```
> julia "Step 1 Calculations.jl"

> julia "Step 1 Calculations.jl"
```

## Contributions

This project was created and developed by [Zach Slonim](https://github.com/zachslonim) as part of a research project in algebra. The research was conducted as part of an REU at Texas State University in the summer of 2022.

## License 

MIT License

Copyright (c) 2023 Zach Slonim

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.