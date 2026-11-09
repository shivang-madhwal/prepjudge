"use client";
import Editor, {loader} from '@monaco-editor/react';
loader.config({paths:{vs:'/monaco/vs'}});
export default function CodeEditor({language,value,onChange}:{language:string,value:string,onChange:(value:string)=>void}){
 return <Editor height="440px" language={language} value={value} onChange={v=>onChange(v||'')} loading={<p className="editor-loading">Loading code editor…</p>} options={{ariaLabel:'Solution code',automaticLayout:true,minimap:{enabled:false},fontSize:14,scrollBeyondLastLine:false,tabSize:4,accessibilitySupport:'on'}}/>;
}
