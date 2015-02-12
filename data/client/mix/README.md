## convert.R 
convert new client data (finer resolution in recording time in millisecond, before in second) to be competible with old client data.

```
Rscript convert.R    [input-file]   [output-file]
```

## latency-outstanding.R

This tool is used to graph the latency and application performance. 

**Note on data filename**: [proto]-[no.learners]-[no.outstanding].csv

e.g, udp-5-5.csv : udp protocol with 5 learners and 5 for outstanding number.


```
Rscript latency-outstanding.R [input-files]*
```

The output figure is named: **fig-latency-outstanding.pdf**