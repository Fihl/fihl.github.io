
// import "./css/index.css";

//import BasicDemo from "./BasicDemo.js";
//import RTLDemo from "./RTLDemo";
//import ButtonThemeDemo from "./ButtonThemeDemo";
//import DOMElementDemo from "./DOMElementDemo";
//import FullKeyboardDemo from "./FullKeyboardDemo";
//import MultipleKeyboardsDemo from "./MultipleKeyboardsDestroyDemo";
import CandidateBoxDemo from "./CandidateBoxDemo.js";

const SELECTED_DEMO = CandidateBoxDemo;

const keyboard = new Keyboard({
  onChange: input => onChange(input),
  onKeyPress: button => onKeyPress(button)
});

function onChange(input){
  document.querySelector(".input").value = input;
  console.log("Input changed", input);
}

function onKeyPress(button){
  console.log("Button pressed", button);
}