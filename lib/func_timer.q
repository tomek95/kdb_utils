// Runtime Analysis Script
// @Author: GitHub@tomek95
// @Date: 2023.01.26

////////////
// RULES //
///////////
// Please read below rules that must apply to the format of a function that this script works for:
// 1) On function definition line, there can be no other statements/lines. Only function name and arguments (if any) are allowed. Examples:
// (A) funcName: ([arg1;arg2] var:string arg1; -> NOT OK
// (B) funcName: {[arg1;arg2] --> OK
// (C) funcName: { --> OK
// (D) funcName: {[] --> OK
// 2) very last line must be a closing curly bracket on its own, example "}" or "};"
// 3) You can not have any lambda functions spanning over multiple lines inside your function. But if it's only defined on a single line that's ok. Examples:
// (A) OK:
//      {I am some lambda but on a single line so Im ok}
// (B) NOT OK:
//    {I am some lambda;
//        but unfortunately I span across multiple lines}
// 4) If using .timer.runFunc, your main function that you pass must have at least 2 lines. If you want to test a single line, use .timer.runCode
// 5) Comments within function are ok (both single line comments and in-line conments)

// VARIABLES
// .timer.result - most recent results from the last run of either .timer.runFunc or .timer.runCode
// .timer.history[0] -> history of all timer.runCode runs only
// .timer.history[UID] -> for every time you run .timer.runFunc. you get a new UID. The key to the history is the UID.
// That's all you really need. Other variables are for library purposes.

///////////////
// FUNCTIONS //
///////////////
// You will most likely only be using
// .timer.runCode (CodeLine : string) -> runs a single line of code, the line is passed as a string
// .timer.runFunc (FunctionName : symbol; Arguments : list) -> runs a function defined in memory with arguments
// .timer.resetStats[] -> will reset history, result, UID, LineID, etc. Start fresh with your stats.

// EXAMPLE USAGES
// .timer.runFunc[`myPrintFunction;5]
// .timer.runFunc[`myAddFunction;(2;5)]
// .timer.runCode ["{x+1;til 10000}each til 200"]

// TO-DO IN THE FUTURE
// (1) improve formatting so functions that have lambdas spanning over multiple lines are accepted. The whole lambda should be evaluated as 1 line.

.timer.result:`UID`LineID xkey ([] UID: `int$(); LineID:`int$(); runType:`symbol$(); code:`symbol$(); startTimeUTC:0Nt;endTimeUTC:0Nt;execTime:0Nt);
.timer.history:()!();
.timer.history[0i]:.timer.result;
.timer.codeLines:()!();
.timer.UID:1i;
.timer.LineID:0i;

.timer.start:{
    .timer.result upsert (.timer.UID;.timer.LineID;`;.timer.codeLines[.timer.LineID];.z.t;0Nt;0Nt);
    };

.timer.end:{
    update endTimeUTC:z.t from .timer.result where UID=.timer.UID, LineID=.timer.LineID;
    .timer.LineID+:1i;
    };

.timer.resetStats:{
    delete from `.timer.result;
    .timer.history:()!();
    .timer.history[0i]:.timer.result;
    .timer.codeLines:()!();
    .timer.UID:1i;
    .timer.LineID:0i;
    };

.timer.runCode: {[code]
    delete from `.timer.result;
    .timer.codeLines:()!();
    .timer.LineID:0i;
    .timer.UID+:1i;
    .timer.codeLines[.timer.LineID]:`$code;
    .timer.start[code];
    res:value code;
    .timer.end[];
    update runType:`code,execTime:endTimeUTC-startTimeUTC from `.timer.result where UID=.timer.UID;
    .timer.history[0i]:.timer.history[0i] upsert .timer.result;
    res
    };

.timer.runFunc:{[funcName;args]
    delete from `.timer.result;
    .timer.codeLines:()!();
    .timer.LineID:0i;
    .timer.UID+:1i;
    newFunc:.timer.prepareFunc[funcName];
    res:$[1=count args;
        @[newFunc;args;{'"Error executing: ",x}];
        @[newFunc;enlist args;{'"Error executing: ",x}]];
    update runType:`func, execTime:endTimeUTC-startTimeUTC from `.timer.result where UID=.timer.UID;
    .timer.history[.timer.UID]:.timer.result;
    res
    };

.timer.prepareFunc:{[funcName]
    newFunc:(trim "\n" vs .Q.s1 value funcName) except enlist "";
    argsLine:first newFunc;
    endLine:last newFunc;
    newFunc:1 _ newFunc;
    newFunc:-1 _ newFunc;
    lastLine:last newFunc;
    newFunc:-1 _ newFunc;
    $[";"=last lastLine;returnValue:0b;returnValue:1b];
    {.timer.codeLines[enlist y]:`$x;} '[newFunc;til count newFunc];
    newFunc:raze {(enlist ".timer.start[]; ",x," .timer.end[];")} each newFunc;
    if[returnValue=0b; lastLine:(enlist ".timer.start[];", lastLine," .timer.end[];")];
    newFunc:newFunc,enlist lastLine;
    newFunc:"\t" ,/: newFunc ,'/ " \n";
    newFunc:(enlist argsLine," \n"),newFunc,(enlist "\t ",endLine);
    newFunc:value raze newFunc;
    newFunc
    };