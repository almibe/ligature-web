import {TabulatorFull as Tabulator} from 'tabulator-tables';
import 'tabulator-tables/dist/css/tabulator_simple.css'
import { initializeRepl } from "./src/repl/Repl.ts"
import "./demo.css"
import { newEngine } from '@ligature/ligature/src/Engine.res.js'

const engine = newEngine()

//      console.log(Object.keys(engine))
engine.addHostFunction("test", () => { TAG: "Ok"; _0: [] })

function getType(value) {
  if (typeof value == "bigint") {
    return "Int"
  } else if (typeof value =="string") {
    return "String"
  } else if (value.identifier !== undefined) {
    return "Identifier"
  } else if (value.slot !== undefined) {
    return "Slot"
  } else if (Array.isArray(value)) {
    return "Quote"
  } else {
    return "Unknown"
  }
}

function printValue(value) {
  if (typeof value == "bigint") {
    return value
  } else if (typeof value =="string") {
    return JSON.stringify(value)
  } else if (value.identifier !== undefined) {
    return "`" + value.identifier + "`"
  } else if (value.slot !== undefined) {
    return "$" + value.slot
  } else if (Array.isArray(value)) {
    return "[" + value.reduce((state, value) => state + " " + printValue(value), "") + "]" //TODO print each value separately, calling printValue
  } else {
    return value          
  }
}

initializeRepl(document.querySelector("#terminal"), (script) => {
  engine.evalScript(script)
  let stack = engine.readStack()

  tabledata.splice(0,tabledata.length)

  let index = 0
  stack.forEach((value) => {
    tabledata.push({id: ++index, value: printValue(value), type: getType(value)})
  })
  return "Okay."
})

var tabledata = [
  {id:1, value:"Empty", type:""},
];
var table = new Tabulator("#stack", {
  reactiveData:true, 
  height:205, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
  data:tabledata, //assign data to table
  layout:"fitColumns", //fit columns to width of table (optional)
  columns:[ //Define Table Columns
    {title:"Stack", field:"value"},
    {title:"Type", field:"type"},
  ],
});