<%--
    Mango - Open Source M2M - http://mango.serotoninsoftware.com
    Copyright (C) 2006-2011 Serotonin Software Technologies Inc.
    @author Matthew Lohbihler
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/.
--%>
<%@page import="com.serotonin.mango.db.dao.SystemSettingsDao"%>
<%@page import="com.serotonin.mango.Common"%>
<%@page import="com.serotonin.mango.rt.event.AlarmLevels"%>
<%@page import="com.serotonin.mango.rt.event.type.EventType"%>
<%@page import="com.serotonin.mango.web.email.MangoEmailContent"%>
<%@ include file="/WEB-INF/jsp/include/tech.jsp" %>

<tag:page dwr="SystemSettingsDwr" onload="init">
  <script type="text/javascript">
    var systemEventAlarmLevels = new Array();
    var auditEventAlarmLevels = new Array();
    
    function init() {
        SystemSettingsDwr.getSettings(function(settings) {
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_HOST %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_HOST %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PORT %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PORT %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_FROM_ADDRESS %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_FROM_ADDRESS %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_FROM_NAME %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_FROM_NAME %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_AUTHORIZATION %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_AUTHORIZATION %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_USERNAME %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_USERNAME %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PASSWORD %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PASSWORD %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_TLS %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_TLS %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_CONTENT_TYPE %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_CONTENT_TYPE %>"/>);
            smtpAuthChange();

            $set("<c:out value="<%= SystemSettingsDao.INSTANCE_NAME %>"/>", settings.<c:out value="<%= SystemSettingsDao.INSTANCE_NAME %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EMAIL_EVENT_HANDLERS_DISABLED %>"/>", settings.<c:out value="<%= SystemSettingsDao.EMAIL_EVENT_HANDLERS_DISABLED %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.SMS_ALARM_LEVEL %>"/>", settings.<c:out value="<%= SystemSettingsDao.SMS_ALARM_LEVEL %>"/>);
            emailEventsChange();
            $set("<c:out value="<%= SystemSettingsDao.SMS_USERNAME %>"/>", settings.<c:out value="<%= SystemSettingsDao.SMS_USERNAME %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.SMS_PASSWORD %>"/>", settings.<c:out value="<%= SystemSettingsDao.SMS_PASSWORD %>"/>);            
            
            var alarmFunctions = [
                function(et) { return et.description; },
                function(et) {
                    var etid = et.typeId +"-"+ et.typeRef1;
                    var content = "<select id='alarmLevel"+ etid +"' ";
                    content += "onchange='updateAlarmLevel("+ et.typeId +", "+ et.typeRef1 +", this.value)'>";
                    content += "<option value='<c:out value="<%= AlarmLevels.NONE %>"/>'><fmt:message key="<%= AlarmLevels.NONE_DESCRIPTION %>"/></option>";
                    content += "<option value='<c:out value="<%= AlarmLevels.INFORMATION %>"/>'><fmt:message key="<%= AlarmLevels.INFORMATION_DESCRIPTION %>"/></option>";
                    content += "<option value='<c:out value="<%= AlarmLevels.URGENT %>"/>'><fmt:message key="<%= AlarmLevels.URGENT_DESCRIPTION %>"/></option>";
                    content += "<option value='<c:out value="<%= AlarmLevels.CRITICAL %>"/>'><fmt:message key="<%= AlarmLevels.CRITICAL_DESCRIPTION %>"/></option>";
                    content += "<option value='<c:out value="<%= AlarmLevels.LIFE_SAFETY %>"/>'><fmt:message key="<%= AlarmLevels.LIFE_SAFETY_DESCRIPTION %>"/></option>";
                    content += "</select> ";
                    content += "<img id='alarmLevelImg"+ etid +"' src='images/flag_green.png' style='display:none'>";
                    return content;
                }
            ];
            var alarmOptions = {
                cellCreator: function(options) {
                    var td = document.createElement("td");
                    td.className = (options.cellNum == 0 ? "formLabelRequired" : "formField");
                    return td;
                }
            };
            setEventTypeData("systemEventAlarmLevelsList", settings.systemEventTypes, alarmFunctions, alarmOptions,
                    systemEventAlarmLevels);
            setEventTypeData("auditEventAlarmLevelsList", settings.auditEventTypes, alarmFunctions, alarmOptions,
                    auditEventAlarmLevels);
            
            $set("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_USE_PROXY %>"/>", settings.<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_USE_PROXY %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_SERVER %>"/>", settings.<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_SERVER %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PORT %>"/>", settings.<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PORT %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_USERNAME %>"/>", settings.<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_USERNAME %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PASSWORD %>"/>", settings.<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PASSWORD %>"/>);
            httpUseProxyChange();
            
            $set("<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIOD_TYPE %>"/>", settings.<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIOD_TYPE %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIODS %>"/>", settings.<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIODS %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIOD_TYPE %>"/>", settings.<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIOD_TYPE %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIODS %>"/>", settings.<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIODS %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.UI_PERFORAMANCE %>"/>", settings.<c:out value="<%= SystemSettingsDao.UI_PERFORAMANCE %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.GROVE_LOGGING %>"/>", settings.<c:out value="<%= SystemSettingsDao.GROVE_LOGGING %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIOD_TYPE %>"/>", settings.<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIOD_TYPE %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIODS %>"/>", settings.<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIODS %>"/>);
            
            $set("<c:out value="<%= SystemSettingsDao.NEW_VERSION_NOTIFICATION_LEVEL %>"/>", settings.<c:out value="<%= SystemSettingsDao.NEW_VERSION_NOTIFICATION_LEVEL %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.INSTANCE_DESCRIPTION %>"/>", settings.<c:out value="<%= SystemSettingsDao.INSTANCE_DESCRIPTION %>"/>);
            
            var sel = $("<c:out value="<%= SystemSettingsDao.LANGUAGE %>"/>");
            <c:forEach items="${availableLanguages}" var="lang">
              sel.options[sel.options.length] = new Option("${lang.value}", "${lang.key}");
            </c:forEach>
            $set(sel, settings.<c:out value="<%= SystemSettingsDao.LANGUAGE %>"/>);
            
            $set("<c:out value="<%= SystemSettingsDao.CHART_BACKGROUND_COLOUR %>"/>", settings.<c:out value="<%= SystemSettingsDao.CHART_BACKGROUND_COLOUR %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.PLOT_BACKGROUND_COLOUR %>"/>", settings.<c:out value="<%= SystemSettingsDao.PLOT_BACKGROUND_COLOUR %>"/>);
            $set("<c:out value="<%= SystemSettingsDao.PLOT_GRIDLINE_COLOUR %>"/>", settings.<c:out value="<%= SystemSettingsDao.PLOT_GRIDLINE_COLOUR %>"/>);
        });
    }
    
    function setEventTypeData(listId, eventTypes, alarmFunctions, alarmOptions, alarmLevelsList) {
        dwr.util.addRows(listId, eventTypes, alarmFunctions, alarmOptions);
        
        var eventType, etid;
        for (var i=0; i<eventTypes.length; i++) {
            eventType = eventTypes[i];
            etid = eventType.typeId +"-"+ eventType.typeRef1;
            $set("alarmLevel"+ etid, eventType.alarmLevel);
            setAlarmLevelImg(eventType.alarmLevel, "alarmLevelImg"+ etid);
            alarmLevelsList[alarmLevelsList.length] = { i1: eventType.typeRef1, i2: eventType.alarmLevel };
        }
    }
    
    function dbSizeUpdate() {
        $set("databaseSize", "<fmt:message key="systemSettings.retrieving"/>");
        $set("filedataSize", "-");
        $set("totalSize", "-");
        $set("historyCount", "-");
        $set("topPoints", "-");
        $set("eventCount", "-");
        hide("refreshImg");
        SystemSettingsDwr.getDatabaseSize(function(data) {
            $set("databaseSize", data.databaseSize);
            $set("filedataSize", data.filedataSize +" ("+ data.filedataCount +" <fmt:message key="systemSettings.files"/>)");
            $set("totalSize", data.totalSize);
            $set("historyCount", data.historyCount);
            show("refreshImg");
            
            var cnt = "";
            for (var i=0; i<data.topPoints.length; i++) {
                cnt += "<a href='data_point_details.shtm?dpid="+ data.topPoints[i].pointId +"'>"+
                        data.topPoints[i].pointName +"</a> "+ data.topPoints[i].count +"<br/>";
                if (i == 3)
                    break;
            }
            $set("topPoints", cnt);
            $set("eventCount", data.eventCount);
        });
    }
    
    function saveEmailSettings() {
        SystemSettingsDwr.saveEmailSettings(
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_HOST %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PORT %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_FROM_ADDRESS %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_FROM_NAME %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_AUTHORIZATION %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_USERNAME %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PASSWORD %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_TLS %>"/>"),
            $get("<c:out value="<%= SystemSettingsDao.EMAIL_CONTENT_TYPE %>"/>"),
            function() {
                stopImageFader("saveEmailSettingsImg");
                setUserMessage("emailMessage", "<fmt:message key="systemSettings.emailSettingsSaved"/>");
            });
        setUserMessage("emailMessage");
        startImageFader("saveEmailSettingsImg");
    }
    
    function sendTestEmail() {
        SystemSettingsDwr.sendTestEmail(
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_HOST %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PORT %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_FROM_ADDRESS %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_FROM_NAME %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_AUTHORIZATION %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_USERNAME %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PASSWORD %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_TLS %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EMAIL_CONTENT_TYPE %>"/>"),
                function(result) {
                    stopImageFader("sendTestEmailImg");
                    if (result.exception)
                        setUserMessage("emailMessage", result.exception);
                    else
                        setUserMessage("emailMessage", result.message);
                });
        setUserMessage("emailMessage");
        startImageFader("sendTestEmailImg");
    }

   	function saveSmsSettings() {
   		SystemSettingsDwr.saveSmsSettings(
   				$get("<c:out value="<%= SystemSettingsDao.SMS_USERNAME %>"/>"),
   				$get("<c:out value="<%= SystemSettingsDao.SMS_PASSWORD %>"/>"),
   				$get("<c:out value="<%= SystemSettingsDao.SMS_ALARM_LEVEL %>"/>"),
   				$get("<c:out value="<%= SystemSettingsDao.INSTANCE_NAME %>"/>"),
   				$get("<c:out value="<%= SystemSettingsDao.EMAIL_EVENT_HANDLERS_DISABLED %>"/>"),
   				function() {
   					stopImageFader("saveSmsSettingsImg");
   					setUserMessage("smsMessage", "SMS Settings Saved");
   				});
   		setUserMessage("smsMessage");
   		startImageFader("saveSmsSettingsImg");
   	}    
    
    function updateAlarmLevel(eventTypeId, eventId, alarmLevel) {
        setAlarmLevelImg(alarmLevel, "alarmLevelImg"+ eventTypeId +"-"+ eventId);
        var list;
        if (eventTypeId == <c:out value="<%= EventType.EventSources.SYSTEM %>"/>)
            list = systemEventAlarmLevels;
        else
            list = auditEventAlarmLevels;
        getElement(list, eventId, "i1")["i2"] = alarmLevel;
    }
    
    function saveSystemEventAlarmLevels() {
        SystemSettingsDwr.saveSystemEventAlarmLevels(systemEventAlarmLevels, function() {
                stopImageFader("saveSystemEventAlarmLevelsImg");
                setUserMessage("systemEventAlarmLevelsMessage", "<fmt:message key="systemSettings.systemAlarmLevelsSaved"/>");
        });
        setUserMessage("systemEventAlarmLevelsMessage");
        startImageFader("saveSystemEventAlarmLevelsImg");
    }
    
    function saveAuditEventAlarmLevels() {
        SystemSettingsDwr.saveAuditEventAlarmLevels(auditEventAlarmLevels, function() {
                stopImageFader("saveAuditEventAlarmLevelsImg");
                setUserMessage("auditEventAlarmLevelsMessage", "<fmt:message key="systemSettings.auditAlarmLevelsSaved"/>");
        });
        setUserMessage("auditEventAlarmLevelsMessage");
        startImageFader("saveAuditEventAlarmLevelsImg");
    }
    
    function smtpAuthChange() {
        var auth = $("<c:out value="<%= SystemSettingsDao.EMAIL_AUTHORIZATION %>"/>").checked;
        setDisabled($("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_USERNAME %>"/>"), !auth);
        setDisabled($("<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PASSWORD %>"/>"), !auth);
    }


	function emailEventsChange() {
    	var emailEvents =  $("<c:out value="<%= SystemSettingsDao.EMAIL_EVENT_HANDLERS_DISABLED %>"/>").checked;
    }    
    
    function saveHttpSettings() {
        SystemSettingsDwr.saveHttpSettings(
                $get("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_USE_PROXY %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_SERVER %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PORT %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_USERNAME %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PASSWORD %>"/>"),
                function() {
                    stopImageFader("saveHttpSettingsImg");
                    setUserMessage("httpMessage", "<fmt:message key="systemSettings.httpSaved"/>");
                });
        setUserMessage("httpMessage");
        startImageFader("saveHttpSettingsImg");
    }
    
    function httpUseProxyChange() {
        var proxy = $("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_USE_PROXY %>"/>").checked;
        setDisabled($("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_SERVER %>"/>"), !proxy);
        setDisabled($("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PORT %>"/>"), !proxy);
        setDisabled($("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_USERNAME %>"/>"), !proxy);
        setDisabled($("<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PASSWORD %>"/>"), !proxy);
    }
    
    function saveMiscSettings() {
        setUserMessage("miscMessage");
        startImageFader("saveMiscSettingsImg");
        SystemSettingsDwr.saveMiscSettings(
                $get("<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIOD_TYPE %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIODS %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIOD_TYPE %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIODS %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.UI_PERFORAMANCE %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.GROVE_LOGGING %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIOD_TYPE %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIODS %>"/>"),
                function() {
                    stopImageFader("saveMiscSettingsImg");
                    setUserMessage("miscMessage", "<fmt:message key="systemSettings.miscSaved"/>");
                }
        );
    }
    
    function saveColourSettings() {
        setUserMessage("colourMessage");
        hideContextualMessages("colourSettingsTab")
        startImageFader("saveColourSettingsImg");
        SystemSettingsDwr.saveColourSettings(
                $get("<c:out value="<%= SystemSettingsDao.CHART_BACKGROUND_COLOUR %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.PLOT_BACKGROUND_COLOUR %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.PLOT_GRIDLINE_COLOUR %>"/>"),
                function(response) {
                    stopImageFader("saveColourSettingsImg");
                    if (response.hasMessages)
                        showDwrMessages(response.messages);
                    else
                        setUserMessage("colourMessage", "<fmt:message key="systemSettings.coloursSaved"/>");
                }
        );
    }
    
    function setUserMessage(type, msg) {
        if (msg)
            $set(type, msg);
        else
            $set(type, "");
    }
    
    function saveInfoSettings() {
        SystemSettingsDwr.saveInfoSettings(
                $get("<c:out value="<%= SystemSettingsDao.NEW_VERSION_NOTIFICATION_LEVEL %>"/>"),
                $get("<c:out value="<%= SystemSettingsDao.INSTANCE_DESCRIPTION %>"/>"),
                function() {
                    stopImageFader("saveInfoSettingsImg");
                    setUserMessage("infoMessage", "<fmt:message key="systemSettings.infoSaved"/>");
                });
        setUserMessage("infoMessage");
        startImageFader("saveInfoSettingsImg");
    }
    
    function newVersionCheck() {
        SystemSettingsDwr.newVersionCheck($get("<c:out value="<%= SystemSettingsDao.NEW_VERSION_NOTIFICATION_LEVEL %>"/>"),
                function(result) {
                    if (!result)
                        result = "<fmt:message key="systemSettings.upToDate"/>";
                    alert(result);
                }
        );
    }
    
    function purgeNow() {
        SystemSettingsDwr.purgeNow(function() {
            stopImageFader("purgeNowImg");
            dbSizeUpdate();
        });
        startImageFader("purgeNowImg");
    }
    
    function saveLangSettings() {
        SystemSettingsDwr.saveLanguageSettings($get("<c:out value="<%= SystemSettingsDao.LANGUAGE %>"/>"), function() {
            stopImageFader("saveLangSettingsImg");
            setUserMessage("langMessage", "<fmt:message key="systemSettings.langSaved"/>");
        });
        setUserMessage("langMessage");
        startImageFader("saveLangSettingsImg");
    }
    
    function checkPurgeAllData() {
        if (confirm("<fmt:message key="systemSettings.purgeDataConfirm"/>")) {
            setUserMessage("miscMessage", "<fmt:message key="systemSettings.purgeDataInProgress"/>");
            SystemSettingsDwr.purgeAllData(function(msg) {
                setUserMessage("miscMessage", msg);
                dbSizeUpdate();
            });
        }
    }
  </script>
  
  <div class="borderDiv marB marR" style="float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.systemInformation"/></span>
          <tag:help id="systemInformation"/>
        </td>
        <td align="right">
          <tag:img id="saveInfoSettingsImg" png="save" onclick="saveInfoSettings();" title="common.save"/>
        </td>
      </tr>
    </table>
    <table>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.version"/></td>
        <td class="formField"><c:out value="<%= Common.getVersion() %>"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.notify"/></td>
        <td class="formField" valign="top">
          <select id="<c:out value="<%= SystemSettingsDao.NEW_VERSION_NOTIFICATION_LEVEL %>"/>">
            <option value="<c:out value="<%= SystemSettingsDao.NOTIFICATION_LEVEL_STABLE %>"/>"><fmt:message key="systemSettings.notifyStable"/></option>
            <option value="<c:out value="<%= SystemSettingsDao.NOTIFICATION_LEVEL_RC %>"/>"><fmt:message key="systemSettings.notifyRC"/></option>
            <option value="<c:out value="<%= SystemSettingsDao.NOTIFICATION_LEVEL_BETA %>"/>"><fmt:message key="systemSettings.notifyBeta"/></option>
          </select>
          <tag:img png="accept" title="systemSettings.checkNow" onclick="newVersionCheck()"/>
        </td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.instanceDescription"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.INSTANCE_DESCRIPTION %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.databaseSize"/></td>
        <td class="formField">
          <span id="databaseSize"></span>
          <tag:img id="refreshImg" png="control_repeat_blue" onclick="dbSizeUpdate();" title="common.refresh"/>
          <tag:img id="purgeNowImg" png="bin" onclick="purgeNow()" title="systemSettings.purgeNow"/>
        </td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.filedataSize"/></td>
        <td class="formField" id="filedataSize"></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.totalSize"/></td>
        <td class="formField" id="totalSize"></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.historyCount"/></td>
        <td class="formField" id="historyCount"></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.topPoints"/></td>
        <td class="formField" id="topPoints"></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.eventCount"/></td>
        <td class="formField" id="eventCount"></td>
      </tr>
      <tr>
        <td colspan="2" id="infoMessage" class="formError"></td>
      </tr>
    </table>
  </div>
  
  <div class="borderDiv marB marR" style="float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.systemAlarmLevels"/></span>
          <tag:help id="systemAlarmLevels"/>
        </td>
        <td align="right">
          <tag:img id="saveSystemEventAlarmLevelsImg" png="save" onclick="saveSystemEventAlarmLevels();"
                  title="common.save"/>
        </td>
      </tr>
    </table>
    <table>
      <tbody id="systemEventAlarmLevelsList"></tbody>
      <tr>
        <td colspan="2" id="systemEventAlarmLevelsMessage" class="formError"></td>
      </tr>
    </table>
  </div>
  
  <div class="borderDiv marB marR" style="float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.auditAlarmLevels"/></span>
          <tag:help id="auditAlarmLevels"/>
        </td>
        <td align="right">
          <tag:img id="saveAuditEventAlarmLevelsImg" png="save" onclick="saveAuditEventAlarmLevels();"
                  title="common.save"/>
        </td>
      </tr>
    </table>
    <table>
      <tbody id="auditEventAlarmLevelsList"></tbody>
      <tr>
        <td colspan="2" id="auditEventAlarmLevelsMessage" class="formError"></td>
      </tr>
    </table>
  </div>
  
  <div class="borderDiv marB marR" style="float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.languageSettings"/></span>
          <tag:help id="languageSettings"/>
        </td>
        <td align="right">
          <tag:img id="saveLangSettingsImg" png="save" onclick="saveLangSettings();" title="common.save"/>
        </td>
      </tr>
    </table>
    <table>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.systemLanguage"/></td>
        <td class="formField">
          <select id="<c:out value="<%= SystemSettingsDao.LANGUAGE %>"/>"></select>
        </td>
      </tr>
      <tr>
        <td colspan="2" id="langMessage" class="formError"></td>
      </tr>
    </table>
  </div>
  
  <div class="borderDiv marB marR" style="clear:left;float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.emailSettings"/></span>
          <tag:help id="emailSettings"/>
        </td>
        <td align="right">
          <tag:img id="saveEmailSettingsImg" png="save" onclick="saveEmailSettings();" title="common.save"/>
          <tag:img id="sendTestEmailImg" png="email_go" onclick="sendTestEmail();" title="common.sendTestEmail"/>
        </td>
      </tr>
    </table>
    <table>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.smtpHost"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_HOST %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.smtpPort"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PORT %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.fromAddress"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_FROM_ADDRESS %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabel"><fmt:message key="systemSettings.fromName"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_FROM_NAME %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.auth"/></td>
        <td class="formField">
          <input id="<c:out value="<%= SystemSettingsDao.EMAIL_AUTHORIZATION %>"/>" type="checkbox" onclick="smtpAuthChange()"/>
        </td>
      </tr>
      <tr>
        <td class="formLabel"><fmt:message key="systemSettings.smtpUsername"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_USERNAME %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabel"><fmt:message key="systemSettings.smtpPassword"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_SMTP_PASSWORD %>"/>" type="password"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.tls"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_TLS %>"/>" type="checkbox"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.contentType"/></td>
        <td class="formField">
          <select id="<c:out value="<%= SystemSettingsDao.EMAIL_CONTENT_TYPE %>"/>">
            <option value="<c:out value="<%= MangoEmailContent.CONTENT_TYPE_BOTH %>"/>"><fmt:message key="systemSettings.contentType.both"/></option>
            <option value="<c:out value="<%= MangoEmailContent.CONTENT_TYPE_HTML %>"/>"><fmt:message key="systemSettings.contentType.html"/></option>
            <option value="<c:out value="<%= MangoEmailContent.CONTENT_TYPE_TEXT %>"/>"><fmt:message key="systemSettings.contentType.text"/></option>
          </select>
        </td>
      </tr>
      
      <tr>
        <td colspan="2" id="emailMessage" class="formError"></td>
      </tr>
    </table>
  </div>

     <div class="borderDiv marB marR" style="clear:left;float:left">
       <table width="100%">
               <tr>
                 <td>
                   <span class="smallTitle">SMS Settings</span>
                   <tag:help id="SmsSettings"/>
                 </td>
                 <td align="right">
                   <tag:img id="saveSmsSettingsImg" png="save" onclick="saveSmsSettings();" title="common.save"/>
                 </td>
               </tr>
             </table>
             <table>
               <tr>
                 <td class="formLabel">Instance Name</td>
                 <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.INSTANCE_NAME %>"/>" type="text"/></td>
               </tr>
               <tr>
                 <td class="formLabel">Alarms Suppressed</td>
                 <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.EMAIL_EVENT_HANDLERS_DISABLED %>"/>" type="checkbox" /></td>
               </tr>
               <tr>
                 <td class="formLabel">SMS Alarm Level</td>
                 <td class="formField">
                 
                           <select id="<c:out value="<%= SystemSettingsDao.SMS_ALARM_LEVEL %>"/>">;
                           <option value='<c:out value="<%= AlarmLevels.NONE %>"/>'><fmt:message key="<%= AlarmLevels.NONE_DESCRIPTION %>"/></option>
                           <option value='<c:out value="<%= AlarmLevels.INFORMATION %>"/>'><fmt:message key="<%= AlarmLevels.INFORMATION_DESCRIPTION %>"/></option>
                           <option value='<c:out value="<%= AlarmLevels.URGENT %>"/>'><fmt:message key="<%= AlarmLevels.URGENT_DESCRIPTION %>"/></option>
                           <option value='<c:out value="<%= AlarmLevels.CRITICAL %>"/>'><fmt:message key="<%= AlarmLevels.CRITICAL_DESCRIPTION %>"/></option>
                           <option value='<c:out value="<%= AlarmLevels.LIFE_SAFETY %>"/>'><fmt:message key="<%= AlarmLevels.LIFE_SAFETY_DESCRIPTION %>"/></option>
                           </select> 
                 </td>
               </tr>                                  
               <tr>
                 <td class="formLabel">SMS Username</td>
                 <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.SMS_USERNAME %>"/>" type="text"/></td>
               </tr>
               <tr>
                 <td class="formLabel">SMS Password</td>
                 <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.SMS_PASSWORD %>"/>" type="text"/></td>
               </tr>
               <tr>
                 <td colspan="2" id="smsMessage" class="formError"></td>
               </tr>
             </table>
             </div>

  
  <div class="borderDiv marB marR" style="float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.httpSettings"/></span>
          <tag:help id="httpSettings"/>
        </td>
        <td align="right">
          <tag:img id="saveHttpSettingsImg" png="save" onclick="saveHttpSettings();" title="common.save"/>
        </td>
      </tr>
    </table>
    <table>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.useProxy"/></td>
        <td class="formField">
          <input id="<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_USE_PROXY %>"/>" type="checkbox"
                  onclick="httpUseProxyChange()"/>
        </td>
      </tr>
      <tr>
        <td class="formLabel"><fmt:message key="systemSettings.proxyHost"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_SERVER %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabel"><fmt:message key="systemSettings.proxyPort"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PORT %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabel"><fmt:message key="systemSettings.proxyUsername"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_USERNAME %>"/>" type="text"/></td>
      </tr>
      <tr>
        <td class="formLabel"><fmt:message key="systemSettings.proxyPassword"/></td>
        <td class="formField"><input id="<c:out value="<%= SystemSettingsDao.HTTP_CLIENT_PROXY_PASSWORD %>"/>" type="password"/></td>
      </tr>
      <tr>
        <td colspan="2" id="httpMessage" class="formError"></td>
      </tr>
    </table>
  </div>
  
  <div class="borderDiv marB marR" style="float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.otherSettings"/></span>
          <tag:help id="otherSettings"/>
        </td>
        <td align="right">
          <tag:img id="saveMiscSettingsImg" png="save" onclick="saveMiscSettings();" title="common.save"/>
        </td>
      </tr>
    </table>
    <table id="miscSettingsTab">
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.uiPerformance"/></td>
        <td class="formField">
          <select id="<c:out value="<%= SystemSettingsDao.UI_PERFORAMANCE %>"/>">
            <option value="2000"><fmt:message key="systemSettings.uiPerformance.high"/></option>
            <option value="5000"><fmt:message key="systemSettings.uiPerformance.med"/></option>
            <option value="10000"><fmt:message key="systemSettings.uiPerformance.low"/></option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.groveLogging"/></td>
        <td class="formField"><input type="checkbox" id="<c:out value="<%= SystemSettingsDao.GROVE_LOGGING %>"/>"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.purgeEvents"/></td>
        <td class="formField">
          <input id="<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIODS %>"/>" type="text" class="formShort"/>
          <select id="<c:out value="<%= SystemSettingsDao.EVENT_PURGE_PERIOD_TYPE %>"/>">
            <tag:timePeriodOptions d="true" w="true" mon="true" y="true"/>
          </select>
        </td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.purgeReports"/></td>
        <td class="formField">
          <input id="<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIODS %>"/>" type="text" class="formShort"/>
          <select id="<c:out value="<%= SystemSettingsDao.REPORT_PURGE_PERIOD_TYPE %>"/>">
            <tag:timePeriodOptions d="true" w="true" mon="true" y="true"/>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2" align="center">
          <input type="button" value="<fmt:message key="systemSettings.purgeData"/>" onclick="checkPurgeAllData()"/>
        </td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.futureDateLimit"/></td>
        <td class="formField">
          <input id="<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIODS %>"/>" type="text" class="formShort"/>
          <select id="<c:out value="<%= SystemSettingsDao.FUTURE_DATE_LIMIT_PERIOD_TYPE %>"/>">
            <tag:timePeriodOptions min="true" h="true"/>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2" id="miscMessage" class="formError"></td>
      </tr>
    </table>
  </div>
  
  <div class="borderDiv marB marR" style="float:left">
    <table width="100%">
      <tr>
        <td>
          <span class="smallTitle"><fmt:message key="systemSettings.colourSettings"/></span>
          <tag:help id="colourSettings"/>
        </td>
        <td align="right">
          <tag:img id="saveColourSettingsImg" png="save" onclick="saveColourSettings();" title="common.save"/>
        </td>
      </tr>
    </table>
    <table id="colourSettingsTab">
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.chartBackgroundColour"/></td>
        <td class="formField"><input type="text" id="<c:out value="<%= SystemSettingsDao.CHART_BACKGROUND_COLOUR %>"/>"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.plotBackgroundColour"/></td>
        <td class="formField"><input type="text" id="<c:out value="<%= SystemSettingsDao.PLOT_BACKGROUND_COLOUR %>"/>"/></td>
      </tr>
      <tr>
        <td class="formLabelRequired"><fmt:message key="systemSettings.plotGridlinesColour"/></td>
        <td class="formField"><input type="text" id="<c:out value="<%= SystemSettingsDao.PLOT_GRIDLINE_COLOUR %>"/>"/></td>
      </tr>
      <tr>
        <td colspan="2" id="colourMessage" class="formError"></td>
      </tr>
    </table>
  </div>
</tag:page>