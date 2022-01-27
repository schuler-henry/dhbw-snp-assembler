# binary-diagnostic
This is a task from the [Advent of Code](https://adventofcode.com/2021/day/3) project.
In order to run, you need an x86 linux machine.
Copying this code is only allowed as mentioned in [License](LICENSE).

## [How-it-works](https://adventofcode.com/2021/day/3)
* There is a given diagnostic report (multiple binary values in text form).
* Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report.
* The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used.
* The power consumption can be calculated by multiplying the gamma rate by the esilon rate.
* The output will show the binary gamma and epsilon value, as well as the decimal power consumption.

## How-to-use
Generate program:
``` powershell
make
```
Execute binary-diagnostic:
``` powershell
./binary-diagnostic64
```

## Authors
* Henry Schuler / [github](https://github.com/schuler-henry) / [E-Mail](mailto:schuler.henry-it20@it.dhbw-ravensburg.de?subject=[GitHub]%20snp-assembler-binary-diagnostic)