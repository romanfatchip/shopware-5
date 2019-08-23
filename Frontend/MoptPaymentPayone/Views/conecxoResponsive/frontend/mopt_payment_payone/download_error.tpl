{extends file='parent:frontend/index/index.tpl'}

{block name="frontend_index_header_javascript"}
    {$smarty.block.parent}
  <script type="text/javascript">
      //<![CDATA[
      if(top!=self){
          top.location=self.location;
      }
      //]]>
  </script>
{/block}

{* Breadcrumb *}
{block name='frontend_index_start'}
    {$smarty.block.parent}
  {$sBreadcrumb = [['name'=>"{s namespace='frontend/MoptPaymentPayone/payment' name=PaymentTitle}Mandat Download{/s}"]]}
{/block}

{* Main content *}
{block name='frontend_index_content'}
  <div class="alert alert-info">{$errormessage|escape|nl2br}</div>
  <br />
  <h3>
    {s name='mandateDownloadError' namespace='frontend/MoptPaymentPayone/payment'}Das Mandat kann nicht heruntergeladen werden.{/s}
  </h3>
{/block}

{block name='frontend_index_actions'}{/block}