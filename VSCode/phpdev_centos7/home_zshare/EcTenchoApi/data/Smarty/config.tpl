<!--{*
/*
 * This file is part of EC-CUBE
 *
 * Copyright(c) 2000-2014 LOCKON CO.,LTD. All Rights Reserved.
 *
 * http://www.lockon.co.jp/
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
*}-->

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_header.tpl"}-->

<h2><!--{$tpl_subtitle}--></h2>

<!--{if $enable}-->
<form name="form1" id="form1" method="post" action="<!--{$smarty.server.REQUEST_URI|h}-->">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="">

<table border="0" cellspacing="1" cellpadding="8" summary=" ">
    <colgroup>
    <col style="width:30%;">
    <col style="width:70%;">
    </colgroup>
     <tr >
        <th>店舗No.</th>
        <td><input name="free_field3" value=<!--{$arrForm.free_field3|h}-->></td>
    </tr>
    <tr >
        <th>APP KEY</th>
        <td><input name="free_field1" value=<!--{$arrForm.free_field1|h}-->></td>
    </tr>
    <tr >
        <th>SECRET KEY</th>
        <td><!--{$arrForm.free_field2|h}-->
            <a class="btn-action" href="javascript:;" onclick="fnModeSubmit('regene', '', '');return false;"><span class="btn-next">KEYを再発給</span></a></td>
    </tr>
    
</table>
		
<div class="btn-area">
    <ul>
        <li>
            <a class="btn-action" href="javascript:;" onclick="fnModeSubmit('regist', '', '');return false;"><span class="btn-next">登録</span></a>
        </li>
    </ul>
</div>
</form>

<!--{else}-->
<p>プラグイン設定を行うには、プラグインを有効にしてください。</p>
<!--{/if}-->

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_footer.tpl"}-->
