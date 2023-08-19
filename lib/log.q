system "c 2000 2000";

.log.startHandle:{
    logfiles:.log.createLogFiles[];
    .log.stdoutH:hopen logfiles[0];
    .log.stderrH:hopen logfiles[1];
    system"2 ",1_string logfiles[0];
 };

.log.endHandle:{
    hclose each (.log.stdoutH;.log.stderrH);
 };

.log.createLogFiles:{
    stdout:hsym `$.log.createFileName[`stdout];
    stderr:hsym `$.log.createFileName[`stderr];
    (stdout;stderr)
 };

.log.createFileName:{[TYPE]
    hostinfo:string .z.h;
    portinfo:string system"p";
    utcdateinfo:string .z.D;
    utctimeinfo:ssr[string .z.T;":";"."];
    fileName:("_" sv (hostinfo;portinfo;utcdateinfo;utctimeinfo));
    fileName:$[TYPE=`stdout;fileName,".log";
        TYPE=`stderr;fileName,".error";
        '"Unknown file type"];
    fileName
 };



.log.info:{

 };

.log.warn:{

 };

.log.error:{

 };

.log.debug:{

 };