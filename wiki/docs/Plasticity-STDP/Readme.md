# Plasticity STDP

# Part A:

In the initial step I create one train of poisson spikes. shown here: 

<img src="Results/partA_1-plotRaster.png" width="60%"/>

and calculate its `ISI` histogram, fano-factor, Cv:

<img src="Results/partA_2-isi.png" width="60%"/>

|key | value|
|:----------- |:-------|
| Fano-Factor | 0.91033 |
| C<sub>v</sub>  |0.93536|

I wrote `stdp_curve` function to calculate synaptic changes.

<img src="Results/partA_3-STDP-curve.png" width="70%"/>

then I illustrate all-to-all scenario for desired results after averaging 30 trails of solution.

<img src="Results/partA_4-func1.png" width="70%"/>

<img src="Results/partA_5-func2.png" width="70%"/>

now I changed `tau_n` and observed that it change in low values of postsynaptic firing-rate.

<img src="Results/partA_6-func3.png" width="70%"/>

## Part B:

I chose following parameters:

| Number of excitatory | Number of inhibitory | Vth | Vr | Ve | Vi | Vsp | C |
|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
| 19 | 11 | -50 mv | -70 mv | 0 mv| 80 mv | -30 mv| 30e-3 |


* Without updating __Wi__ in time 
  

<img src="Results/partB_1-v.png" width="100%"/>

<img src="Results/partB_2-ge-gi.png" width="100%"/>

* Just updating __Wi__ for the first presynaptic neuron

<img src="Results/partB3_1-v.png" width="100%"/>

<img src="Results/partB3_2-ge-gi.png" width="100%"/>


* Updating __Wi__ for all presynaptic neurons

<img src="Results/partB2_1-v.png" width="100%"/>

<img src="Results/partB2_2-ge-gi.png" width="100%"/>

* In the case which updating __Wi__ for the first presynaptic neuron, we have following graph

  > I changed inhibitory presynaptic neurons' firing-rate to change postsynaptic firing-rate randomly by multiplying their firing-rates into a parameter named `alpha` changed from 0.8 to 4.

<img src="Results/partB4_postFiringRate.png" width="80%"/>

According to above figure, we can see some kind of saturation when postsynaptic firing-rate is increased. we can also see in low firing-rate a sagittal curve.  



## Part C:

At the first step, I created 1000 paired firing-rate as pre and post synaptic one.  in this case I used `mvnrnd` matlab command to generate following paired data.

<img src="Results/partC_1-Hebb-u1u2.png" width="40%"/>

#### Hebb Rule

I set its average on (0,0), then used Hebb Rule. because of instability of this rule we cannot use following formulas. 

<img src="Readme/1.png" width="20%"/>

So according to [the paper](http://www.gatsby.ucl.ac.uk/~lmate/biblio/dayanabbott.pdf), I replaced that with auto-correlation form.

<img src="Readme/2.png" width="20%"/>

Where Q is :

<img src="Readme/3.png" width="30%"/>

we can observe that __w__ stretches along maximum covariance direction. we notice that if mu is equal to zero, covariance and auto-correlation matrix has the same meaning.



<img src="Results/partC_2-Hebb-w1.png" width="40%"/>

I also illustrated the first principal component that show the maximum covariance direction. so both of them referred to the same thing.

<img src="Results/partC_3-Hebb-pca.png" width="40%"/>

In the next step, I turned its average into (2,2). we can observe that it's been changed.

<img src="Results/partC_4-Hebb-w2.png" width="40%"/>

#### Covariance Rule

Similar to previous step we must change formulas to get more stability. so I assigned `Q = cov(u)` in matlab. that's because we chose average of __u__ as &theta; (the threshold parameter).

<img src="Results/partC_5-Cov-w1.png" width="40%"/>

we can observe it not sensitive of changing its average.

<img src="Results/partC_6-Cov-w2.png" width="40%"/>

#### BCM Rule

There is extra formulas to implement in this section:

<img src="Readme/4.png" width="50%"/>

And the results is like bellow:

<img src="Results/partC_7-BCM-w1.png" width="40%"/>



<img src="Results/partC_8-BCM-w2.png" width="40%"/>



