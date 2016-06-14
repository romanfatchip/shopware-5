{namespace name='frontend/MoptPaymentPayone/payment'}

{if $payment_mean.id == $form_data.payment}
    {assign var="moptRequired" value=1}
{else}
    {assign var="moptRequired" value=0}
{/if}

<div class="payment--form-group">
    
    {if ($fcPayolutionConfig.payolutionB2bmode == 0 && $sUserData.billingaddress.birthday == "0000-00-00") || ( $fcPayolutionConfig.payolutionB2bmode == 1 && $sUserData.billingaddress.birthday == "0000-00-00" && !$sUserData.billingaddress.company  ) }
        <p class ="none">
            <label for="mopt_payone__payolution_debitnote_birthday">
                {s name='birthdate'}Geburtsdatum{/s}
            </label>
        </p>

        <select name="moptPaymentData[mopt_payone__payolution_debitnote_birthday]" 
                id="mopt_payone__payolution_debitnote_birthday" 
                {if $payment_mean.id == $form_data.payment}required="required" aria-required="true"{/if}
                class="payment--field {if $error_flags.mopt_payone__payolution_debitnote_birthday} has--error{/if}">
            <option disabled="disabled" value="">--</option>
            {section name="birthdate" start=1 loop=32 step=1}
                <option value="{$smarty.section.birthdate.index}" 
                        {if $smarty.section.birthdate.index eq $moptCreditCardCheckEnvironment.mopt_payone__payolution_debitnote_birthday}
                            selected
                        {/if}>
                    {$smarty.section.birthdate.index}</option>
                {/section}
        </select>
        
        <select name="moptPaymentData[mopt_payone__payolution_debitnote_birthmonth]" 
                id="mopt_payone__payolution_debitnote_birthmonth" 
                {if $payment_mean.id == $form_data.payment}required="required" aria-required="true"{/if}
                class="payment--field {if $error_flags.mopt_payone__payolution_debitnote_birthmonth} has--error{/if}">
            <option disabled="disabled" value="">-</option>
            {section name="birthmonth" start=1 loop=13 step=1}
                <option value="{$smarty.section.birthmonth.index}" 
                        {if $smarty.section.birthmonth.index eq $moptCreditCardCheckEnvironment.mopt_payone__payolution_debitnote_birthmonth}
                            selected
                        {/if}>
                    {$smarty.section.birthmonth.index}</option>
                {/section}
        </select>

        <select name="moptPaymentData[mopt_payone__payolution_debitnote_birthyear]" 
                id="mopt_payone__payolution_debitnote_birthyear" 
                {if $payment_mean.id == $form_data.payment}required="required" aria-required="true"{/if}
                class="payment--field {if $error_flags.mopt_payone__payolution_debitnote_birthyear} has--error{/if}">
            <option disabled="disabled" value="">----</option>
            {section name="birthyear" loop=2000 max=100 step=-1}
                <option value="{$smarty.section.birthyear.index}" 
                        {if $smarty.section.birthyear.index eq $moptCreditCardCheckEnvironment.mopt_payone__payolution_debitnote_birthyear}
                            selected
                        {/if}>
                    {$smarty.section.birthyear.index}</option>
                {/section}
        </select>        
    {/if}
    
    <input class="is--hidden" type="text" name="moptPaymentData[mopt_payone__payolution_birthdaydate]" id="moptPaymentData[mopt_payone__payolution_birthdaydate]" value="{$sUserData.billingaddress.birthday}">   
    
    {if $fcPayolutionConfig.payolutionB2bmode && $sUserData.billingaddress.company}
        <input type="text" name="moptPaymentData[mopt_payone__debitnote_company_trade_registry_number]" 
                id="mopt_payone__debitnote_company_trade_registry_number" 
                {if $payment_mean.id == $form_data.payment}required="required" aria-required="true"{/if}
                placeholder="{s name='companyTradeRegistryNumber'}Handelsregisternummer*{/s}{s name="RequiredField" namespace="frontend/register/index"}{/s}"                
                class="payment--field is--required {if $error_flags.mopt_payone__debitnote_company_trade_registry_number} has--error{/if}" />
        <input class="is--hidden" type="text" name="moptPaymentData[mopt_payone__payolution_b2bmode]" id="moptPaymentData[mopt_payone__payolution_b2bmode]" value="1">   
   {/if}    

    <input name="moptPaymentData[mopt_payone__debit_iban]"
           type="text"
           id="mopt_payone__debit_iban"
           {if $moptRequired}required="required" aria-required="true"{/if}
           placeholder="{s name='bankIBAN'}IBAN{/s}{s name="RequiredField" namespace="frontend/register/index"}{/s}"
           value="{$form_data.mopt_payone__debit_iban|escape}" 
           data-moptIbanErrorMessage="{s namespace='frontend/MoptPaymentPayone/errorMessages' name="ibanbicFormField"}Dieses Feld darf nur Großbuchstaben und Ziffern enthalten{/s}"
           class="payment--field {if $moptRequired}is--required{/if}{if $error_flags.mopt_payone__debit_iban} has--error{/if} moptPayoneIbanBic" />

    <input name="moptPaymentData[mopt_payone__debit_bic]"
           type="text"
           id="mopt_payone__debit_bic"
           {if $moptRequired}required="required" aria-required="true"{/if}
           placeholder="{s name='bankBIC'}BIC{/s}{s name="RequiredField" namespace="frontend/register/index"}{/s}"
           value="{$form_data.mopt_payone__debit_bic|escape}" 
           data-moptIbanErrorMessage="{s namespace='frontend/MoptPaymentPayone/errorMessages' name="ibanbicFormField"}Dieses Feld darf nur Großbuchstaben und Ziffern enthalten{/s}"
           class="payment--field {if $moptRequired}is--required{/if}{if $error_flags.mopt_payone__debit_bic} has--error{/if} moptPayoneIbanBic" />        

        <p class="none clearfix">
            <input name="moptPaymentData[mopt_payone__debit_agreement]" type="checkbox" id="mopt_payone__debit_agreement" value="true"
                   {if $form_data.mopt_payone__debit_agreement eq "on"}
                       checked="checked"
                   {/if}
                   class="checkbox{if $error_flags.mopt_payone__debit_agreement} has--error{/if}"/>
            <label for="mopt_payone__debit_agreement"  style="float:none; width:100%; display:inline">{$moptCreditCardCheckEnvironment.moptPayolutionInformation.consent}</label>
        </p>
        <div class="register--required-info">{$moptCreditCardCheckEnvironment.moptPayolutionInformation.legalTerm}</div>

        <p class="none clearfix">
            <input name="moptPaymentData[mopt_payone__debit_agreement2]" type="checkbox" id="mopt_payone__debit_agreement2" value="true"
                   {if $form_data.mopt_payone__debit_agreement2 eq "on"}
                       checked="checked"
                   {/if}
                   class="checkbox{if $error_flags.mopt_payone__debit_agreement2} has--error{/if}"/>
            <label for="mopt_payone__debit_agreement2"  style="float:none; width:100%; display:inline">{$moptCreditCardCheckEnvironment.moptPayolutionInformation.sepaagreement}</label>
        </p>

    {block name='frontend_checkout_payment_required'}
        {* Required fields hint *}
        <div class="register--required-info">
            {s name='RegisterPersonalRequiredText' namespace='frontend/register/personal_fieldset'}{/s}
        </div>
    {/block}    


</div>
