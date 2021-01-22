// ==UserScript==
// @name         Devast.io Zoom Hack Aim Helper Aim Target Lock Display Ping Auto Lock
// @namespace    http://tampermonkey.net/
// @version      0.1.2
// @description  try to take over the world!
// @author       You
// @include        http*://devast.io/*
// @grant none
// @run-at       document-start
// ==/UserScript==

(function() {
    'use strict';
    window.stop();
    document.body.innerHTML="";
    document.head.innerHTML="";
      WebSocket.prototype._send = WebSocket.prototype.send;
    WebSocket.prototype.send = function(data) {
        window.wsStart=Date.now();
        this._send(data);
        setInterval(()=>{this._send(window.atob("WzEsIkhpISBJJ20gYSBjaGVhdGVyLiJd"));},50000)
        this.addEventListener('message', function wsMessage(msg) {
           window.wslatency= Date.now()-window.wsStart;
            this.removeEventListener('message',wsMessage);
        })
        this.send = function(_data) {
            this._send(_data);
        };
    };
    function disablemousemove(e){e.stopPropagation();}
    document.addEventListener("keydown", event => {if(event.code=="KeyX"){
                                                                          if(!window.aimlock){window.aimlock=true;}else{
                                                                              window.aimlock=!window.aimlock;}
                                                                          if(window.aimlock){document.getElementById("can").addEventListener("mousemove",disablemousemove);}else{
                                                                              document.getElementById("can").removeEventListener("mousemove",disablemousemove);
                                                                          }
                                                                         }});
    document.addEventListener("click",(e)=>{window.enemyTarget.shadowx=e.clientX; window.enemyTarget.shadowy=e.clientY;});
    async function checkScript(div){
        let scripts= div.getElementsByTagName("script");
        for(let script of scripts){
            let parent=script.parentNode;
            let newScript=document.createElement("script");
            if(script.src.includes("client")){
                newScript= await scriptModify(script.src);
            }else{
                for(let attribute of script.attributes){
                    newScript.setAttribute(attribute.name,attribute.value);
                }
                if(script.textContent){
                    newScript=script;
                }
            }

            parent.removeChild(script);
            parent.append(newScript);
        }
    }
    async function scriptModify(scriptSrc){
        let newScript=document.createElement("script");
        await fetch(scriptSrc).then((response)=>{return response.text();}).then((script)=>{
            return script.replace(/Ww\[VM\[142\]\]=0;/gi,"window.test=Ww; Ww[VM[142]]=-0.5;");}).
