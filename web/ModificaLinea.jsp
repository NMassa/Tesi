<%@page import="blogics.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="util.Conversion"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1" session="false"%>
<%//@page import="services.sessionservice.*" %>
<%@page import="util.*"%>

<%@page buffer="40kb" %>
<%@page errorPage="/ErrorPage.jsp" %>

<jsp:useBean id="userManagement" scope="page" class="bflows.UserManagement"/>
<jsp:setProperty name="userManagement" property="*"/>
        
<% 
    String status;    
    status = request.getParameter("status");
    
    if(status == null)
        status = "view";    
             
    if(status.equals("editPhoneView")){
        userManagement.viewEditPhone();
    }else if(status.equals("addSubscription")){
        userManagement.addSubscription();
    }else if(status.equals("deleteSubscription")){
        userManagement.deleteSubscription();
    }else if(status.equals("addDevice")){
        userManagement.addDevice();
    }else if(status.equals("deleteDevice")){
        userManagement.deleteDevice();
    }
    %>
 
<%@include file="Header.jsp" %>
<%  if(userManagement.getErrorMessage() != null)
    {%>     
    <div class="titolo">
        Si � verificato un Errore!
    </div>
    <div class="testo">
    <%=userManagement.getErrorMessage()%>
        <br/><br/><br/>
        <a href="Index.jsp">
            <div class="button goHome-button">Torna all'Home Page</div>
        </a>
        <br/>
    </div>
<%}else if(status.equals("editPhoneView") || status.equals("addSubscription") || status.equals("deleteSubscription") || status.equals("addDevice") || status.equals("deleteDevice"))
{%>      
    
    <form class="back-button" name="back" method="post" action="ModificaUtente.jsp">
        <input type="hidden" name="email" value="<%=userManagement.getSelectedUser().Email%>">
        <input type="hidden" name="status" value="editUserView">
        <input type="image" alt="indietro" name="submit" src="images/back.png">        
        <br/>
        <span class="f10">indietro</span>
    </form>
    <div class="titolo">
        <b>Utente <%=userManagement.getSelectedUser().Cognome%> <%=userManagement.getSelectedUser().Nome%> - Numero <%=userManagement.getSelectedTelefono().Numero%></b>
    </div>

    <div class="titolo"><b>Modifica Numero</b></div>          
    <div class="testo">
        <form method="post" action="ModificaUtente.jsp" onsubmit="return editTelefonoOnSubmit(this)">
            <table class="invisible-table" cellspacing="0" >
                <tr>
                    <td>Numero</td>      
                    <td>
                        <input type="text" name="newnumero" placeholder="esempio: 123-1234567" size="30" maxlength="20" value="<%=userManagement.getSelectedTelefono().Numero%>">
                    </td>
                </tr>                
            </table>
            <input type="hidden" name="idTelefono" value="<%=userManagement.getSelectedTelefono().IdTelefono%>"/>
            <input type="hidden" name="email" value="<%=userManagement.getSelectedUser().Email%>"/>
            <input type="hidden" name="status" value="editPhone"/>
            <input type="submit" value="Modifica Numero"/>
        </form>
    </div> 
            
    <div class="col">                 
        <div class="titolo"><b>Gestione Contributi Abbonamenti</b></div>          
        <div class="testo" >        
            <%if(userManagement.getSelectedTelefono().IdContributo > 0)
            {%>
            <table class="table-classic" cellspacing="0"> 
                <tr>
                    <td class="w50"><b>Nome</b></td>
                    <td class="w25"><center><b>Costo</b></center></td>
                    <td class="w25"><center><b>Elimina</b></center></td>
                </tr>
                <%for(Contributo c : userManagement.getContributi())
                {
                    if(c.IdContributo == userManagement.getSelectedTelefono().IdContributo)
                    {%>   
                    <tr>
                        <td class="w50"> 
                            <%=c.Nome%>
                        </td>
                        <td class="w25">
                        <center><%=c.Costo%></center>
                        </td>
                        <td class="w25">
                            <form name="del" method="post" action="ModificaLinea.jsp" onsubmit="return deleteTContributoOnSubmit()">
                                <input type="hidden" name="idContributo" value="<%=c.IdContributo%>">
                                <input type="hidden" name="idTelefono" value="<%=userManagement.getSelectedTelefono().IdTelefono%>"/>
                                <input type="hidden" name="email" value="<%=userManagement.getSelectedUser().Email%>"/>
                                <input type="hidden" name="status" value="deleteSubscription">
                                <center><input type="image" name="submit" src="images/delete.jpg"></center>
                            </form>
                        </td>
                    </tr>
                <%  }
                }%>
            </table>   
            <%}else{%>
            Nessun contributo o abbonamento associato al numero <%=userManagement.getSelectedTelefono().Numero%>
            <%}%>
        </div>
        <div class="titolo">
            <b>
                <%if(userManagement.getSelectedTelefono().IdContributo == 0){%>
                Aggiungi un contributo o abbonamento
                <%}else{%>
                Sostituisci contributo o abbonamento con
                <%}%>                
            </b>
        </div>
        <div class="testo">
            <form name="fregister" method="post" action="ModificaLinea.jsp">  
                <select name="idContributo">
                    <%for(Contributo c : userManagement.getContributi())
                    {%>
                        <option value="<%=c.IdContributo%>"><%=c.Nome%></option>
                    <%}%>
                </select>                
                <input type="hidden" name="idTelefono" value="<%=userManagement.getSelectedTelefono().IdTelefono%>"/>
                <input type="hidden" name="email" value="<%=userManagement.getSelectedUser().Email%>"/>
                <input type="hidden" name="status" value="addSubscription"/>
                <center>
                    <%if(userManagement.getSelectedTelefono().IdContributo == 0){%>
                    <input type="submit" value="Aggiungi"/>
                    <%}else{%>
                    <input type="submit" value="Sostituisci"/>
                    <%}%>                     
                </center>
            </form>
        </div>  
    </div>
    <div class="col">                 
        <div class="titolo"><b>Gestione Dispositivi</b></div>          
        <div class="testo" >        
            <%if(userManagement.getSelectedTelefono().IdDispositivo > 0)
            {%>
            <table class="table-classic"> 
                <tr>
                    <td class="w50"><b>Nome</b></td>
                    <td class="w25"><center><b>Costo</b></center></td>
                    <td class="w25"><center><b>Elimina</b></center></td>
                </tr>
                <%for(Dispositivo d : userManagement.getDispositivi())
                {
                    if(d.IdDispositivo == userManagement.getSelectedTelefono().IdDispositivo)
                    {%>   
                    <tr>
                        <td class="w50"> 
                            <%=d.Nome%>
                        </td>
                        <td class="w25">
                        <center><%=d.Costo%></center>
                        </td>
                        <td class="w25">
                            <form name="del" method="post" action="ModificaLinea.jsp" onsubmit="return deleteTDispositivoOnSubmit()">
                                <input type="hidden" name="idDispositivo" value="<%=d.IdDispositivo%>">
                                <input type="hidden" name="idTelefono" value="<%=userManagement.getSelectedTelefono().IdTelefono%>"/>
                                <input type="hidden" name="email" value="<%=userManagement.getSelectedUser().Email%>"/>
                                <input type="hidden" name="status" value="deleteDevice">
                                <center><input type="image" name="submit" src="images/delete.jpg"></center>
                            </form>
                        </td>
                    </tr>
                <%  }
                }%>
            </table>  
            <%}else{%>
            Nessun dispositivo associato al numero <%=userManagement.getSelectedTelefono().Numero%>
            <%}%>
        </div>
        <div class="titolo">
            <b>
                <%if(userManagement.getSelectedTelefono().IdContributo == 0){%>
                Aggiungi un dispositivo
                <%}else{%>
                Sostituisci dispositivo con
                <%}%>    
            </b>
        </div>
        <div class="testo">
            <form name="fregister" method="post" action="ModificaLinea.jsp">  
                <select name="idDispositivo">
                    <%for(Dispositivo d : userManagement.getDispositivi())
                    {%>
                        <option value="<%=d.IdDispositivo%>"><%=d.Nome%></option>
                    <%}%>
                </select>                
                <input type="hidden" name="idTelefono" value="<%=userManagement.getSelectedTelefono().IdTelefono%>"/>
                <input type="hidden" name="email" value="<%=userManagement.getSelectedUser().Email%>"/>
                <input type="hidden" name="status" value="addDevice"/>
                <center>
                    <%if(userManagement.getSelectedTelefono().IdDispositivo == 0){%>
                    <input type="submit" value="Aggiungi"/>
                    <%}else{%>
                    <input type="submit" value="Sostituisci"/>
                    <%}%>                     
                </center>
            </form>
        </div>  
    </div>
<%}%>
 <%@include file="Footer.jsp" %>
