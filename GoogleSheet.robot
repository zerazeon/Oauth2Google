*** Settings ***
Library    lib/Oauth2Google.py
Library    Collections
Library    REST

*** Variables ***
${SHEETS_URL}     https://sheets.googleapis.com/v4/spreadsheets
${SHEETS_ID}      12s2lIKxptnOdkBUyfApN856I
${SHEETS_NAME}    Firebase Daily Report

*** Keywords ***
Get Token
    ${getToken}    Get Variable Value    ${getToken}    ${false}
    Return From Keyword If    ${getToken} == ${true}
    ${accessToken}    Get Access Token
    Set Headers    {"Content-Type":"application/json","Authorization":"Bearer ${accessToken}"}
    Set Global Variable    ${getToken}    ${true}

Get Values
    [Arguments]    ${range}
    Get Token
    Get    ${SHEETS_URL}/${SHEETS_ID}/values/${SHEETS_NAME}!${range}
    ${output}    Output    response body values    ${TEMPDIR}/output.json
    [Return]    ${output}

Set Value
    [Arguments]    ${range}    ${value}
    Get Token
    Put    ${SHEETS_URL}/${SHEETS_ID}/values/${SHEETS_NAME}!${range}:${range}?valueInputOption=USER_ENTERED    body={"values":[["${value}"]]}
    ${output}    Output    response body    ${TEMPDIR}/output.json
    [Return]    ${output}

Get Today Date
    ${y}    ${m}    ${d}    Get Time    year,month,day
    ${d}    Convert To Integer    ${d}
    ${m}    Convert To Integer    ${m}
    ${y}    Convert To Integer    ${y}
    [Return]    ${d}/${m}/${y}

Get List Of Date
    ${output}    Get Values    A1:A
    ${date}    Create List
    FOR    ${value}    IN    @{output}
    Exit For Loop If    ${value} == []
    Append To List    ${date}    ${value[0]}
    END
    [Return]    ${date}

Set Report
    [Arguments]    ${field}    ${value}
    ${today}    Get Today Date
    ${date}    Get List Of Date
    ${condition}    Evaluate    '${today}' not in ${date}
    ${lastIndex}    Get Length    ${date}
    Run Keyword If    ${condition}    Set Value    A${lastIndex+1}    ${today}
    Run Keyword If    ${condition}    Append To List    ${date}    ${today}
    ${todayIndex}    Get Index From List    ${date}    ${today}
    ${range}    Set Variable    ${field}${todayIndex+1}
    Set Value    ${range}    ${value}
