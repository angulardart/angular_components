self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={QL:function QL(d,e){this.a=d
this.$ti=e},
a8P:function(d,e,f,g){var y,x,w,v,u,t,s,r,q,p,o,n=null,m=e.length
if(m!==0){w=0
while(!0){if(!(w<m)){y=""
x=0
break}if(C.e.bI(e,w)===64){y=C.e.b0(e,0,w)
x=w+1
break}++w}if(x<m&&C.e.bI(e,x)===91){for(v=x,u=-1;v<m;++v){t=C.e.bI(e,v)
if(t===37&&u<0){s=C.e.dE(e,"25",v+1)?v+2:v
u=v
v=s}else if(t===93)break}if(v===m)throw H.n(P.bM("Invalid IPv6 host entry.",e,x))
r=u<0?v:u
P.a1A(e,x+1,r);++v
if(v!==m&&C.e.bI(e,v)!==58)throw H.n(P.bM("Invalid end of authority",e,v))}else v=x
while(!0){if(!(v<m)){q=n
break}if(C.e.bI(e,v)===58){p=C.e.cB(e,v+1)
q=p.length!==0?P.eA(p,n,n):n
break}++v}o=C.e.b0(e,x,v)}else{q=n
o=q
y=""}return P.and(o,n,H.a(f.split("/"),[P.i]),q,g,d,y)}},W,G={
lv:function(d,e){var y,x=new G.O0(E.L(d,e,1)),w=$.a8q
if(w==null)w=$.a8q=O.T($.aCt,null)
x.b=w
y=document.createElement("simple-html")
x.c=y
return x},
aKq:function(d){return new G.Y3(d,new G.K())},
a8o:function(d,e){var y,x=new G.O_(E.L(d,e,1)),w=$.a8p
if(w==null)w=$.a8p=O.T($.aCs,null)
x.b=w
y=document.createElement("simple-html-block")
x.c=y
return x},
aKp:function(d){return new G.Y2(d,new G.K())},
ahB:function(){if($.a9r)return
$.a9r=!0
$.N.D(0,C.oX,C.iB)
$.N.D(0,C.oW,C.j_)
E.C()
V.ds()},
O0:function O0(d){var _=this
_.c=_.b=_.a=null
_.d=d},
Y3:function Y3(d,e){var _=this
_.b=_.a=null
_.c=d
_.d=e},
O_:function O_(d){var _=this
_.c=_.b=_.a=null
_.d=d},
Y2:function Y2(d,e){var _=this
_.b=_.a=null
_.c=d
_.d=e},
hO:function hO(d){this.a=d}},Y={Jq:function Jq(){}},R={k_:function k_(){this.a=0}},K,V,S={lr:function lr(){}},E={
amt:function(){return C.eg},
aKo:function(d){return new E.Y1(d,new G.K())},
arr:function(){if($.a9p)return
$.a9p=!0
$.N.D(0,C.oV,C.eg)
E.C()
K.cX()
D.cC()
A.asN()
F.atH()},
NZ:function NZ(d){var _=this
_.c=_.b=_.a=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
Y1:function Y1(d,e){var _=this
_.b=_.a=null
_.c=d
_.d=e}},M,Q,D,L,Z,O,B,A={
aKs:function(d){return new A.Y5(d,new G.K())},
asN:function(){if($.acZ)return
$.acZ=!0
$.N.D(0,C.oY,C.e8)
E.C()
G.ahB()},
O2:function O2(d){var _=this
_.c=_.b=_.a=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
Y5:function Y5(d,e){var _=this
_.b=_.a=null
_.c=d
_.d=e}},U,T,N,X,F={
lq:function(d,e,f,g){var y=f==null?$.a3K():f
y=F.a9b(y,E.eR(g,!1))
return new F.lp(e,d,new P.j(null,null,[W.ac]),new R.D(!1),new F.wY(y))},
a5d:function(d,e,f,g){var y,x=f==null?$.a3K():f
x=F.a9b(x,E.eR(g,!1))
y=[P.i]
x.h2("p",H.a(["class"],y))
x.h2("ul",H.a(["class"],y))
x.h2("li",H.a(["class"],y))
return new F.lo(e,d,new P.j(null,null,[W.ac]),new R.D(!1),new F.wY(x))},
QM:function(d,e){return new F.xm(!1,null,null,"Unsafe URI "+H.z(d)+" because "+e)},
PI:function(d,e){return new F.w3(!1,null,null,"Element "+H.z(d)+" was malformed: "+e)},
a9e:function(d){var y,x,w=null
try{w=P.a1z(d)}catch(y){H.aH(y)
x=F.QM(d,"Could not parse")
throw H.n(x)}return P.a5k().p6(w)},
ana:function(d){var y=new F.Qe(P.mf(d,P.f8))
y.K5(d)
return y},
a9b:function(d,e){var y=e?new F.P7():F.ana(d),x=new W.q4(H.a([],[W.fJ])),w=[P.i]
x.F4("a",H.a(["class","href","rel","target","title"],w),y)
x.h2("b",H.a(["class"],w))
x.h2("br",H.a(["class"],w))
x.h2("em",H.a(["class"],w))
x.h2("i",H.a(["class"],w))
x.h2("span",H.a(["class"],w))
x.h2("strong",H.a(["class"],w))
return x},
lp:function lp(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
lo:function lo(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
Qi:function Qi(){},
Ql:function Ql(d,e){this.a=d
this.b=e},
Qk:function Qk(d){this.a=d},
Qj:function Qj(d){this.a=d},
xm:function xm(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
w3:function w3(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
wY:function wY(d){this.a=d},
Qe:function Qe(d){this.a=d},
Qg:function Qg(){},
Qf:function Qf(d){this.a=d},
P7:function P7(){},
aKr:function(d){return new F.Y4(d,new G.K())},
atH:function(){if($.a9q)return
$.a9q=!0
$.N.D(0,C.px,C.eu)
E.C()
G.ahB()},
O1:function O1(d){var _=this
_.c=_.b=_.a=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
Y4:function Y4(d,e){var _=this
_.b=_.a=_.e=null
_.c=d
_.d=e}}
a.setFunctionNamesIfNecessary([P,G,Y,R,S,E,A,F])
C=c[0]
H=c[1]
J=c[2]
P=a.updateHolder(c[3],P)
W=c[4]
G=a.updateHolder(c[5],G)
Y=a.updateHolder(c[6],Y)
R=a.updateHolder(c[7],R)
K=c[8]
V=c[9]
S=a.updateHolder(c[10],S)
E=a.updateHolder(c[11],E)
M=c[12]
Q=c[13]
D=c[14]
L=c[15]
Z=c[16]
O=c[17]
B=c[18]
A=a.updateHolder(c[19],A)
U=c[20]
T=c[21]
N=c[22]
X=c[23]
F=a.updateHolder(c[24],F)
P.QL.prototype={
aP:function(d,e){return J.a0L(this.a,e)},
gb2:function(d){return J.bF(J.a0P(this.a))},
gJ:function(d){return J.bu(this.a)},
P:function(d,e){throw H.n(P.aj("Cannot change unmodifiable set"))},
bl:function(d,e){throw H.n(P.aj("Cannot change unmodifiable set"))}}
F.lp.prototype={
gHR:function(d){var y=this.f,x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.oa(y,x)
y=y.gdD(y)}return y}}
F.lo.prototype={
gHR:function(d){var y=this.f,x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.oa(y,x)
y=y.gdD(y)}return y}}
F.Qi.prototype={
sh3:function(d){this.a.cQ(new F.Ql(this,d))}}
F.xm.prototype={}
F.w3.prototype={}
F.wY.prototype={
fp:function(d){if(!this.a.fp(d))throw H.n(F.PI(d,"prohibited element"))
return!0},
fd:function(d,e,f){var y
if(d.tagName.toLowerCase()==="a"&&e==="target"){if(!d.hasAttribute("rel"))throw H.n(F.PI(d,"did not set rel attribute"))
y=d.getAttribute("rel")
if(!C.d.aP(H.a(y.split(" "),[P.i]),"noopener"))throw H.n(F.PI(d,"did not set link type noopener (only "+y+")"))}if(!this.a.fd(d,e,f))throw H.n(F.PI(d,"prohibited attribute "+e+" with value "+H.z(f)))
return!0},
$ifJ:1}
F.Qe.prototype={
K5:function(d){C.d.b_(this.a,new F.Qg())},
ld:function(d){var y,x,w,v=F.a9e(d),u=null
try{u=J.akh(v)}catch(y){H.aH(y)
x=F.QM(d,"Resolved URI "+H.z(v)+" had no origin")
throw H.n(x)}x=u
w=P.a5k()
if(!J.a3(x,w.ghk(w))&&!this.NK(v))throw H.n(F.QM(d,"Different origin and non-whitelisted URL"))
return!0},
NK:function(d){return C.d.cZ(this.a,new F.Qf(d))}}
F.P7.prototype={
ld:function(d){var y=F.a9e(d)
if(!J.a0L(C.ml.a,y.ghy()))throw H.n(F.QM(d,"URI scheme "+H.z(y.ghy())+" not allowed"))
return!0}}
G.O0.prototype={
p:function(){var y=this.a2()
this.l(T.dp(document,y))}}
G.Y3.prototype={
p:function(){var y,x=this,w=G.lv(x,0)
x.b=w
y=w.c
w=F.lq(x.m(C.b,null),y,x.k(C.aH,null),null)
x.a=w
x.E(y)},
v:function(){this.b.i()},
F:function(){this.b.j()
this.a.d.G()},
$ak:function(){return[F.lp]}}
G.O_.prototype={
p:function(){var y=this.a2()
this.h(T.u(document,y))}}
G.Y2.prototype={
p:function(){var y,x=this,w=G.a8o(x,0)
x.b=w
y=w.c
w=F.a5d(x.m(C.b,null),y,x.k(C.aH,null),null)
x.a=w
x.E(y)},
v:function(){this.b.i()},
F:function(){this.b.j()
this.a.d.G()},
$ak:function(){return[F.lo]}}
R.k_.prototype={
Zl:function(){return this.a++}}
A.O2.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.a,g=j.a2(),f=document,e=T.d(f,g,"h2")
j.l(e)
T.b(e,"SimpleHTML with default URI whitelist")
y=T.d(f,g,"p")
j.l(y)
x=G.lv(j,3)
j.e=x
w=x.c
y.appendChild(w)
j.h(w)
x=j.d
v=x.a
x=x.b
u=F.lq(v.m(C.b,x),w,v.k(C.aH,x),i)
j.f=u
j.e.K(0,u)
t=T.d(f,g,"ul")
j.h(t)
s=T.d(f,t,"li")
j.l(s)
u=G.lv(j,6)
j.r=u
r=u.c
s.appendChild(r)
j.h(r)
u=F.lq(v.m(C.b,x),r,v.k(C.aH,x),i)
j.x=u
j.r.K(0,u)
q=T.d(f,t,"li")
j.l(q)
u=G.lv(j,8)
j.y=u
p=u.c
q.appendChild(p)
j.h(p)
u=F.lq(v.m(C.b,x),p,v.k(C.aH,x),i)
j.z=u
j.y.K(0,u)
o=T.d(f,g,"p")
j.l(o)
T.b(o,"The following message is removed due to disallowed HTML: [")
u=G.lv(j,11)
j.Q=u
n=u.c
o.appendChild(n)
j.h(n)
u=F.lq(v.m(C.b,x),n,v.k(C.aH,x),i)
j.ch=u
j.Q.K(0,u)
T.b(o,"]")
m=T.d(f,g,"p")
j.l(m)
u=G.lv(j,14)
j.cx=u
l=u.c
m.appendChild(l)
j.N(l,"click-target")
j.h(l)
u=F.lq(v.m(C.b,x),l,v.k(C.aH,x),i)
j.cy=u
j.cx.K(0,u)
u=G.a8o(j,15)
j.db=u
k=u.c
g.appendChild(k)
j.h(k)
x=F.a5d(v.m(C.b,x),k,v.k(C.aH,x),i)
j.dx=x
j.db.K(0,x)
x=j.cy.c
j.bt(H.a([new P.o(x,[H.e(x,0)]).B(j.ad(h.gZk(),W.ac))],[[P.S,-1]]))},
v:function(){var y,x,w,v,u,t,s,r,q,p,o=this,n=null,m=o.a
m.toString
y=[P.l]
x=H.a(["<b>","</b>",'<span class="highlight">',"</span>"],y)
w=$.aO().bu('I <b>love</b> using <span class="highlight">HTML</span>.',n,"SimpleHtmlExampleMessages_messageWithFormatting",x,n)
x=o.dy
if(x!=w){o.f.sh3(w)
o.dy=w
v=!0}else v=!1
if(v)o.e.d.st(1)
x=H.a(['<a href="localpage.html?param=1#test_fragment">',"</a>"],y)
u=$.aO().bu('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',n,"SimpleHtmlExampleMessages_messageLink",x,n)
x=o.fr
if(x!=u){o.x.sh3(u)
o.fr=u
v=!0}else v=!1
if(v)o.r.d.st(1)
x=H.a(['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],y)
t=$.aO().bu('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',n,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",x,n)
x=o.fx
if(x!=t){o.z.sh3(t)
o.fx=t
v=!0}else v=!1
if(v)o.y.d.st(1)
x=H.a(['<a href="https://hecuba.org">',"</a>"],y)
s=$.aO().bu('Please consult my <a href="https://hecuba.org">suspicious website</a>.',n,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",x,n)
x=o.fy
if(x!=s){o.ch.sh3(s)
o.fy=s
v=!0}else v=!1
if(v)o.Q.d.st(1)
x=m.a
r='You <a class="trigger">clicked here</a> '+x+" times."
x=H.a([x,'<a class="trigger">',"</a>"],y)
q=$.aO().bu(r,n,"SimpleHtmlExampleMessages_messageWithClickHandler",x,n)
x=o.go
if(x!=q){o.cy.sh3(q)
o.go=q
v=!0}else v=!1
if(v)o.cx.d.st(1)
y=H.a(["<b>","</b>","<ul>","</ul>","<li>","</li>"],y)
p=$.aO().bu("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",n,"SimpleHtmlExampleMessages_blockMessage",y,n)
y=o.id
if(y!=p){o.dx.sh3(p)
o.id=p
v=!0}else v=!1
if(v)o.db.d.st(1)
o.e.i()
o.r.i()
o.y.i()
o.Q.i()
o.cx.i()
o.db.i()},
F:function(){var y=this
y.e.j()
y.r.j()
y.y.j()
y.Q.j()
y.cx.j()
y.db.j()
y.f.d.G()
y.x.d.G()
y.z.d.G()
y.ch.d.G()
y.cy.d.G()
y.dx.d.G()}}
A.Y5.prototype={
p:function(){var y,x=this,w=new A.O2(E.L(x,0,3)),v=$.a8s
if(v==null)v=$.a8s=O.T($.aCu,null)
w.b=v
y=document.createElement("simple-html-example")
w.c=y
x.b=w
x.a=new R.k_()
x.E(y)},
$ak:function(){return[R.k_]}}
S.lr.prototype={}
F.O1.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o=this,n="(removed)",m=o.a2(),l=document
T.b(T.d(l,m,"h2"),"SimpleHTML with a custom URI whitelist")
y=T.d(l,m,"ul")
x=T.d(l,y,"li")
w=G.lv(o,4)
o.e=w
v=w.c
x.appendChild(v)
w=o.d
u=w.a
w=w.b
t=F.lq(u.m(C.b,w),v,u.k(C.aH,w),null)
o.f=t
o.e.K(0,t)
s=T.d(l,y,"li")
t=G.lv(o,6)
o.r=t
r=t.c
s.appendChild(r)
t=F.lq(u.m(C.b,w),r,u.k(C.aH,w),null)
o.x=t
o.r.K(0,t)
T.b(s,n)
q=T.d(l,y,"li")
t=G.lv(o,9)
o.y=t
p=t.c
q.appendChild(p)
w=F.lq(u.m(C.b,w),p,u.k(C.aH,w),null)
o.z=w
o.y.K(0,w)
T.b(q,n)},
v:function(){var y,x,w,v,u,t=this,s="</a>"
t.a.toString
y=C.c9.qV('<a href="'+H.z(P.on(C.cu,"https://wordpress.org/plugins/amp/",C.aK,!1))+'">',s)
x=t.Q
if(x!=y){t.f.sh3(y)
t.Q=y
w=!0}else w=!1
if(w)t.e.d.st(1)
v=C.c9.qV('<a href="'+H.z(P.on(C.cu,"https://wordpress.org/plugins/malware/",C.aK,!1))+'">',s)
x=t.ch
if(x!=v){t.x.sh3(v)
t.ch=v
w=!0}else w=!1
if(w)t.r.d.st(1)
u=C.c9.qV('<a href="'+H.z(P.on(C.cu,"javascript:alert('!')",C.aK,!1))+'">',s)
x=t.cx
if(x!=u){t.z.sh3(u)
t.cx=u
w=!0}else w=!1
if(w)t.y.d.st(1)
t.e.i()
t.r.i()
t.y.i()},
F:function(){var y=this
y.e.j()
y.r.j()
y.y.j()
y.f.d.G()
y.x.d.G()
y.z.d.G()}}
F.Y4.prototype={
p:function(){var y,x=this,w=new F.O1(E.L(x,0,3)),v=$.a8r
if(v==null){v=new O.bb(null,C.a,"","","")
v.bG()
$.a8r=v}w.b=v
y=document.createElement("simple-html-custom-whitelist-example")
w.c=y
x.b=w
x.a=new S.lr()
x.E(y)},
O:function(d,e,f){var y
if(d===C.aH&&0===e){y=this.e
if(y==null){y=P.f8
y=this.e=P.mf(H.a([P.a8P("https","developers.google.com","",null),P.a8P("https","wordpress.org","plugins/amp/",null)],[y]),y)}return y}return f},
$ak:function(){return[S.lr]}}
Y.Jq.prototype={
qV:function(d,e){var y="Visit "+d+"this site"+d+"!",x=H.a([d,e],[P.l])
return $.aO().bu(y,null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",x,null)}}
G.hO.prototype={}
E.NZ.prototype={
gmi:function(){var y=this.r
return y==null?this.r=document:y},
gxg:function(){var y=this.y
return y==null?this.y=window:y},
gmj:function(){var y,x=this,w=x.z
if(w==null){w=x.d
y=w.a
w=w.b
w=T.bc(y.k(C.b,w),y.k(C.E,w),y.m(C.f,w),x.gxg())
x.z=w}return w},
gx5:function(){var y,x=this,w=x.Q
if(w==null){w=x.d
w=w.a.m(C.W,w.b)
y=x.gmj()
w=x.Q=new O.aR(w,y)}return w},
gpH:function(){var y=this,x=y.ch
return x==null?y.ch=new K.aW(y.gmi(),y.gmj(),P.b9(null,[P.r,P.i])):x},
gK0:function(){var y=this.cx
if(y==null){y=this.d
y=T.bg(y.a.m(C.f,y.b))
this.cx=y}return y},
gu6:function(){var y=this.cy
if(y==null){y=this.d
y=G.bn(y.a.k(C.t,y.b))
this.cy=y}return y},
gDy:function(){var y=this,x=y.db
if(x==null){x=y.d
x=G.bq(y.gmi(),x.a.k(C.u,x.b))
y.db=x}return x},
gDz:function(){var y=this,x=y.dx
if(x==null){x=y.d
x=G.bf(y.gu6(),y.gDy(),x.a.k(C.r,x.b))
y.dx=x}return x},
gu7:function(){var y=this.dy
return y==null?this.dy=!0:y},
gDA:function(){var y=this.fr
return y==null?this.fr=!0:y},
gxa:function(){var y=this.fy
if(y==null){y=this.gmi()
y=this.fy=new R.aU(y.querySelector("head"),y)}return y},
gxh:function(){var y=this.go
return y==null?this.go=X.bl():y},
gx9:function(){var y=this,x=y.id
return x==null?y.id=K.bk(y.gxa(),y.gDz(),y.gu6(),y.gpH(),y.gmj(),y.gx5(),y.gu7(),y.gDA(),y.gxh()):x},
gK2:function(){var y,x,w,v,u=this,t=u.k1
if(t==null){t=u.d
y=t.a
t=t.b
x=y.m(C.f,t)
w=u.gu7()
v=u.gx9()
y.k(C.k,t)
t=u.k1=new X.aQ(w,x,v)}return t},
p:function(){var y,x=this,w=x.a2(),v=K.co(x,0)
x.e=v
w.appendChild(v.c)
v=x.d
y=v.a
v=v.b
y.m(C.ad,v)
v=y.m(C.ae,v)
v=new X.ao(v,!J.bo(window.location.href,"enableLatencyCharts=false"))
x.f=v
x.e.K(0,v)},
O:function(d,e,f){var y,x=this
if(0===e){if(d===C.N)return x.gmi()
if(d===C.X){y=x.x
return y==null?x.x=document:y}if(d===C.K)return x.gxg()
if(d===C.b)return x.gmj()
if(d===C.R)return x.gx5()
if(d===C.P)return x.gpH()
if(d===C.a1)return x.gK0()
if(d===C.t)return x.gu6()
if(d===C.u)return x.gDy()
if(d===C.r)return x.gDz()
if(d===C.V)return x.gu7()
if(d===C.G)return x.gDA()
if(d===C.H){y=x.fx
return y==null?x.fx=C.a_:y}if(d===C.T)return x.gxa()
if(d===C.F)return x.gxh()
if(d===C.S)return x.gx9()
if(d===C.k)return x.gK2()
if(d===C.I){y=x.k2
return y==null?x.k2=C.a0:y}if(d===C.w){y=x.k3
return y==null?x.k3=new K.b0(x.gpH()):y}}return f},
v:function(){var y=this,x=y.a.a,w=y.k4
if(w!==x)y.k4=y.f.a=x
y.e.i()},
F:function(){this.e.j()}}
E.Y1.prototype={
p:function(){var y,x,w,v=this,u="angular_components/lib/simple_html/simple_html.dart",t=new E.NZ(E.L(v,0,3)),s=$.a8n
if(s==null){s=new O.bb(null,C.a,"","","")
s.bG()
$.a8n=s}t.b=s
y=document.createElement("simple-html-api")
t.c=y
v.b=t
t=[D.c8]
t=H.a([new D.jA("README","angular_components/lib/simple_html/README.md",X.f('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p><ul><li>  Light formatting (bold, italic, newlines).</li><li>  Links to external domains (with a customisable whitelist).</li><li>  Arbitrary click handlers on substrings within the text.</li></ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p><ul><li>  Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li><li>  Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li></ul>\n<p>The alternatives include:</p><ul><li>  Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.<ul><li>  This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li></ul></li><li>  Using the <code>[innerHtml]</code> directive with a string argument.<ul><li>  This is secure but very strict; only very limited tags are allowed.</li><li>  The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li><li>  The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li></ul></li><li>  Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.<ul><li>  This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li></ul></li></ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p><ol><li>\n<p> Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p></li><li>\n<p> Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p></li><li>\n<p> Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p></li><li>\n<p> Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p></li></ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p><ul><li>  <code>&lt;simple-html&gt;</code> supports the following safe inline elements:<ul><li>  Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li><li>  Line breaks: <code>&lt;br&gt;</code>.</li><li>  Text grouping: <code>&lt;span&gt;</code>.</li><li>  Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>, points to\ncertain permitted URIs such as the Help Center, or uses the\n<code>doNotVerifyUrlDestinations</code> flag; see\n(<a href="#uri-whitelisting">URI whitelisting</a>).<ul><li>  The <code>rel</code> attributes are permitted.</li><li>  The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li><li>  The <code>title</code> attribute is permitted.</li></ul></li></ul></li><li>  <code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:<ul><li>  Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li><li>  Paragraphs: <code>&lt;p&gt;</code>.</li></ul></li></ul>\n<p>The <code>class</code> attribute is permitted by all elements.</p>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h4>Allowing external URIs without a whitelist</h4>\n<p>There are cases where you can not use a whitelist:</p><ul><li>  when exposing a whitelist through client code is not acceptable, or</li><li>  the whitelist is not fixed</li></ul>\n<p>When the URIs come from a <em>safe</em> source, such as internally sourced URIs, you\ncan consider enabling the <code>doNotVerifyUrlDestinations</code> flag. This will allow any\nURI with the <code>http</code>, <code>https</code> or <code>mailto</code> scheme to be inserted, and should\ntherefore be used with caution.</p>\n<p>For example:</p>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html doNotVerifyUrlDestinations\n               [contents]="internalMessages.someMessage"&gt;&lt;/simple-html&gt;\n&lt;/my-template&gt;\n</code></pre>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p><ul><li>  Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li><li>  Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li></ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p><ul><li>  Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li><li>  More dangerous cases (such as setting the URL of an iframe) must still be\ndone using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at all.)</li></ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p><ol><li> Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li><li> Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular/Component-class.html">@Component</a>\'s\ndirective list.</li><li> For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li><li> In your template file, bind the message with either:<ul><li>  <code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span\n[innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li><li>  <code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li></ul></li><li> Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li><li> Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li><li> If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li></ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p><ul><li>  <strong>The message appears empty</strong><ul><li>  Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li></ul></li></ul>\n')),D.aE("SimpleHtmlComponent",!1,"","simple-html","",u,X.f('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p><ul><li>  <code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li><li>  <code>&lt;span&gt;</code> <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with (optionally) a <code>class</code>\n  attribute.</li></ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the attribute doNotVerifyUrlDestinations is present, external URLs will\nnot be verified, except for their URI scheme. This is flag should only ever\nbe used for URLs that come from a safe source, such as internal\ndocumentation.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.a([D.h("Input","contents","","String",X.f("<p>HTML to display in the component.</p>\n"),u,!1,"")],t),H.a([D.h("Output","trigger","","Stream<UIEvent>",X.f("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),u,!1,"")],t))],[D.c1])
x=H.a([new R.ag(C.e8,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.ag(C.eu,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],[R.ag])
w=P.i
v.a=new G.hO(R.ct(H.a([],[w]),x,t,P.aq(w,w),!0))
v.E(y)},
$ak:function(){return[G.hO]}}
var z=a.updateTypes([{func:1,ret:-1},{func:1,ret:[G.k,F.lp],args:[M.t]},{func:1,ret:[G.k,F.lo],args:[M.t]},{func:1,ret:[G.k,R.k_],args:[M.t]},{func:1,ret:[G.k,S.lr],args:[M.t]},{func:1,ret:[G.k,G.hO],args:[M.t]}])
F.Ql.prototype={
$0:function(){var y,x,w,v=this.a
if(v.b==null)v.b=v.gHR(v)
v.d.G()
x=v.b
if(x==null)return
try{J.akw(x,this.b,v.e)}catch(w){y=H.aH(w)
if(y instanceof F.xm)$.a3F().jQ(C.eZ,"simple-html used untrusted URI: "+H.z(y),y,null)
else if(y instanceof F.w3)$.a3F().jQ(C.eZ,"simple-html used malformed element: "+H.z(y),y,null)
else throw w}v.a.dB(new F.Qk(v))},
$S:0}
F.Qk.prototype={
$0:function(){var y=this.a,x=W.aA
new H.cv(new W.ka(y.b.querySelectorAll("a.trigger"),[x]),new F.Qj(y),[x,[P.S,W.aF]]).b_(0,H.lN(y.d.gF0(),W.aF))},
$S:0}
F.Qj.prototype={
$1:function(d){var y=J.akf(d),x=this.a.c
return W.ci(y.a,y.b,x.giH(x),!1,H.e(y,0))},
$S:242}
F.Qg.prototype={
$1:function(d){var y=d.gd5(d).length===0||C.e.jm(d.gd5(d),"/"),x="Whitelisted URIs with a path must end with a slash, which "+d.M(0)+" does not"
if(!y)H.Q(P.cF(N.aoh(x,null)))
return},
$S:177}
F.Qf.prototype={
$1:function(d){var y=this.a
return d.ghk(d)===y.ghk(y)&&C.e.cm(y.gd5(y),d.gd5(d))},
$S:178};(function installTearOffs(){var y=a._static_1,x=a._instance_0u
y(G,"aAi","aKq",1)
y(G,"aAh","aKp",2)
x(R.k_.prototype,"gZk","Zl",0)
y(A,"aAg","aKs",3)
y(F,"aAf","aKr",4)
y(E,"aqR","aKo",5)})();(function inheritance(){var y=a.inherit,x=a.inheritMany
y(P.QL,P.wW)
x(P.l,[F.Qi,F.wY,F.Qe,F.P7,R.k_,S.lr,Y.Jq,G.hO])
x(F.Qi,[F.lp,F.lo])
x(H.b8,[F.Ql,F.Qk,F.Qj,F.Qg,F.Qf])
x(P.eV,[F.xm,F.w3])
x(E.b5,[G.O0,G.O_,A.O2,F.O1,E.NZ])
x(G.k,[G.Y3,G.Y2,A.Y5,F.Y4,E.Y1])})();(function constants(){var y=a.makeConstList
C.c9=new Y.Jq()
C.iB=new D.B("simple-html",G.aAi(),[F.lp])
C.e8=new D.B("simple-html-example",A.aAg(),[R.k_])
C.eg=new D.B("simple-html-api",E.aqR(),[G.hO])
C.eu=new D.B("simple-html-custom-whitelist-example",F.aAf(),[S.lr])
C.j_=new D.B("simple-html-block",G.aAh(),[F.lo])
C.cu=H.a(y([0,0,65498,45055,65535,34815,65534,18431]),[P.E])
C.aH=new S.dT("simpleHtmlUriWhitelist",[[P.r,P.f8]])
C.lr=H.a(y(["http","https","mailto"]),[P.i])
C.lW=new H.cc(3,{http:null,https:null,mailto:null},C.lr,[P.i,P.O])
C.ml=new P.QL(C.lW,[P.i])
C.oV=H.A(G.hO)
C.oW=H.A(F.lo)
C.oX=H.A(F.lp)
C.oY=H.A(R.k_)
C.px=H.A(S.lr)})();(function staticFields(){$.aif=["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]
$.a8q=null
$.a8p=null
$.a9r=!1
$.aCx=["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]
$.a8s=null
$.acZ=!1
$.a8r=null
$.a9q=!1
$.a8n=null
$.a9p=!1
$.aCt=[$.aif]
$.aCs=[$.aif]
$.aCu=[$.aCx]})();(function lazyInitializers(){var y=a.lazy
y($,"aMQ","a3K",function(){var x=P.f8
return P.mf(H.a([],[x]),x)})
y($,"aMC","a3F",function(){return N.tw("_SimpleHtmlBase")})})()}
$__dart_deferred_initializers__["ARhvi3xAS1QYLy0Un/d2AJaSGvE="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_70.part.js.map
