system "c 2000 2000";
.params.dict:()!();
.params.raw:()!();

.params.getRaw:{
    .params.raw:.Q.opt[.z.X];
    .params.raw[`script]:first .z.X;
    .params.raw[`dbpath]:$[(dbpathpos:(first where .z.X in first .params.raw)-2)=1;.z.X dbpathpos;enlist""];
 };

.params.parse:{

 };

.params.add:{[input;isrequired;default]

 }

.params.start:{

 }