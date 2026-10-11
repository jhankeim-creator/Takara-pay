<?php if(isset($transactions)): ?>
    <?php $__empty_1 = true; $__currentLoopData = $transactions; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
        <div class="dashboard-list-item-wrapper">
            <div class="dashboard-list-item sent">
                <div class="dashboard-list-left">
                    <div class="dashboard-list-user-wrapper">
                        <div class="dashboard-list-user-icon">
                            <?php if(@$item->attribute == payment_gateway_const()::SEND): ?>
                            <i class="las la-dollar-sign"></i>
                            <?php else: ?>
                            <i class="las la-dollar-sign"></i>
                            <?php endif; ?>
                        </div>
                        <div class="dashboard-list-user-content">
                            <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                                <h4 class="title"><?php echo e(__("Add Balance via")); ?> <span class="text--warning"><?php echo e(@$item->currency->name); ?></span></h4>
                            <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>
                                <h4 class="title"><?php echo e(__("Withdraw Money")); ?> <span class="text--warning"><?php echo e(@$item->currency->gateway->name); ?></span></h4>
                            <?php elseif(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                                <h4 class="title"><?php echo e(__("Virtual Card")); ?> <span class="text--info">(<?php echo e(__(@$item->remark)); ?>)</span></h4>
                            <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                                <h4 class="title"><?php echo e(__("Balance Update From Admin")); ?> <?php echo e("(".@$item->user_wallet->currency->code.")"); ?></h4>
                            <?php elseif(@$item->type == payment_gateway_const()::TYPETRANSFERMONEY): ?>
                                <?php if(@$item->isAuthUser()): ?>

                                    <?php if(@$item->attribute == payment_gateway_const()::SEND): ?>
                                        <h4 class="title"><?php echo e(__("Transfer Money to") . " @" . @$item->details->receiver->username . " (" . @$item->details->receiver->email . ")"); ?> </h4>
                                    <?php elseif(@$item->attribute == payment_gateway_const()::RECEIVED): ?>
                                        <h4 class="title"><?php echo e(__("Transfer Money from") . " @" . @$item->details->sender->username . " (" . @$item->details->sender->email . ")"); ?> </h4>
                                    <?php endif; ?>
                                <?php endif; ?>
                            <?php elseif($item->type == payment_gateway_const()::GIFTCARD): ?>
                                <h4 class="title"><?php echo e(__("Gift Card")); ?></h4>
                            <?php endif; ?>
                            <span class="<?php echo e(@$item->stringStatus->class); ?>"><?php echo e(__( @$item->stringStatus->value)); ?> </span>
                        </div>
                    </div>
                </div>
                <div class="dashboard-list-right">
                    <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                        <h4 class="main-money text--warning"><?php echo e(get_amount(@$item->request_amount,get_default_currency_code(),get_wallet_precision())); ?></h4>
                        <h6 class="exchange-money fw-bold"><?php echo e(isCrypto($item->payable,$item->currency->currency_code??get_default_currency_code(),$item->currency->gateway->crypto)); ?></h6>
                    <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>
                        <h6 class="exchange-money text--warning fw-bold"><?php echo e(get_amount(@$item->request_amount,get_default_currency_code(),get_wallet_precision())); ?></h6>
                        <h4 class="main-money "><?php echo e(get_amount(@$item->payable,get_default_currency_code(),get_wallet_precision())); ?></h4>
                    <?php elseif(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                        <h4 class="main-money text--warning"><?php echo e(get_amount($item->request_amount,$item->details->card_info->currency??get_default_currency_code(),get_wallet_precision())); ?></h4>
                        <h6 class="exchange-money fw-bold"><?php echo e(get_amount($item->payable,get_default_currency_code(),get_wallet_precision())); ?></h6>
                    <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                        <h4 class="main-money text--base"><?php echo e(get_amount(@$item->request_amount,@$item->user_wallet->currency->code,get_wallet_precision())); ?></h4>
                        <h6 class="exchange-money"><?php echo e(get_amount(@$item->available_balance,@$item->user_wallet->currency->code,get_wallet_precision())); ?></h6>
                    <?php elseif(@$item->type == payment_gateway_const()::TYPETRANSFERMONEY): ?>
                        <?php if(@$item->attribute == payment_gateway_const()::SEND): ?>
                        <h6 class="exchange-money text--warning "><?php echo e(get_amount(@$item->request_amount,get_default_currency_code(),get_wallet_precision())); ?></h6>
                        <h4 class="main-money fw-bold"><?php echo e(get_amount(@$item->payable,get_default_currency_code(),get_wallet_precision())); ?></h4>
                        <?php elseif(@$item->attribute == payment_gateway_const()::RECEIVED): ?>
                        <h6 class="exchange-money fw-bold"><?php echo e(get_amount(@$item->request_amount,get_default_currency_code(),get_wallet_precision())); ?></h6>
                        <?php endif; ?>
                    <?php elseif($item->type == payment_gateway_const()::GIFTCARD): ?>
                        <h4 class="main-money text--warning"><?php echo e(get_amount($item->request_amount,$item->details->charge_info->wallet_currency,get_wallet_precision())); ?></h4>
                        <h6 class="exchange-money fw-bold"><?php echo e(get_amount($item->payable,$item->details->charge_info->wallet_currency,get_wallet_precision())); ?></h6>
                    <?php endif; ?>
                </div>
            </div>
            <div class="preview-list-wrapper">

                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="lab la-tumblr"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Transaction ID")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span><?php echo e(@$item->trx_id); ?></span>
                    </div>
                </div>
                <?php if(@$item->type != payment_gateway_const()::TYPETRANSFERMONEY ): ?>
                <?php if(@$item->type != payment_gateway_const()::VIRTUALCARD ): ?>
                <div class="preview-list-item">

                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="las la-exchange-alt"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Exchange Rate")); ?></span>
                            </div>
                        </div>
                    </div>

                    <div class="preview-list-right">
                        <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                        <span>1 <?php echo e(get_default_currency_code()); ?> = <?php echo e(isCrypto(@$item->currency->rate??1,$item->currency->currency_code??get_default_currency_code(),$item->currency->gateway->crypto)); ?></span>
                        <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>
                        <span>1 <?php echo e(get_default_currency_code()); ?> = <?php echo e(isCrypto(@$item->currency->rate??1,$item->currency->currency_code??get_default_currency_code(),$item->currency->gateway->crypto)); ?></span>
                        <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                            <span>1 <?php echo e(get_default_currency_code()); ?> = <?php echo e(get_amount(@$item->user_wallet->currency->rate,@$item->user_wallet->currency->code,get_wallet_precision())); ?></span>
                        <?php elseif(@$item->type == payment_gateway_const()::GIFTCARD): ?>
                        <?php echo e(get_amount(1,@$item->details->charge_info->card_currency) ." = ". get_amount(@$item->details->charge_info->exchange_rate,@$item->details->charge_info->wallet_currency,get_wallet_precision())); ?>


                        <?php endif; ?>
                    </div>
                </div>
                <?php endif; ?>
                <?php endif; ?>

                <?php if(@$item->type == payment_gateway_const()::BILLPAY ): ?>
                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="las la-balance-scale"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Bill Type")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span class="text--base"><?php echo e(@$item->details->bill_type_name); ?></span>
                    </div>
                </div>
                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="las la-balance-scale"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Bill Number")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span class="text--base"><?php echo e(@$item->details->bill_number); ?></span>
                    </div>
                </div>
                <?php endif; ?>
                <?php if(@$item->type == payment_gateway_const()::MOBILETOPUP ): ?>
                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="las la-balance-scale"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Topup Type")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span class="text--base"><?php echo e(@$item->details->topup_type_name); ?></span>
                    </div>
                </div>
                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="fas fa-mobile"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Mobile Number")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span class="text--base"><?php echo e(@$item->details->mobile_number); ?></span>
                    </div>
                </div>
                <?php endif; ?>


                <?php if(@$item->type == payment_gateway_const()::TYPETRANSFERMONEY): ?>
                    <?php if(@$item->attribute == payment_gateway_const()::SEND): ?>
                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-battery-half"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span><?php echo e(__("Fees & Charges")); ?></span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span><?php echo e(get_amount(@$item->charge->total_charge,@$item->user_wallet->currency->code,get_wallet_precision())); ?></span>
                            </div>
                        </div>
                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="lab la-get-pocket"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span><?php echo e(__("recipient Received")); ?></span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span><?php echo e(get_amount(@$item->details->recipient_amount,get_default_currency_code(),get_wallet_precision())); ?></span>
                            </div>
                        </div>

                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-balance-scale"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span><?php echo e(__("Current Balance")); ?></span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span class="text--success fw-bold"><?php echo e(get_amount(@$item->available_balance,get_default_currency_code(),get_wallet_precision())); ?></span>
                            </div>
                        </div>
                    <?php else: ?>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-balance-scale"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Current Balance")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="text--success fw-bold"><?php echo e(get_amount(@$item->available_balance,get_default_currency_code(),get_wallet_precision())); ?></span>
                        </div>
                    </div>
                    <?php endif; ?>
                <?php else: ?>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-battery-half"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Fees & Charges")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                                <span><?php echo e(isCrypto($item->charge->total_charge??0,$item->currency->currency_code??get_default_currency_code(),$item->currency->gateway->crypto)); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>
                                <span><?php echo e(get_amount(@$item->charge->total_charge,get_default_currency_code(),get_wallet_precision())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::BILLPAY): ?>
                                <span><?php echo e(get_amount(@$item->charge->total_charge,get_default_currency_code())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::MOBILETOPUP): ?>
                                <span><?php echo e(get_amount(@$item->charge->total_charge,get_default_currency_code())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                                <span><?php echo e(get_amount(@$item->charge->total_charge,get_default_currency_code(),get_wallet_precision())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::TYPEMONEYEXCHANGE): ?>
                                <span><?php echo e(get_amount(@$item->details->total_charge,@$item->user_wallet->currency->code)); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                                <span><?php echo e(get_amount(@$item->charge->total_charge,@$item->user_wallet->currency->code,get_wallet_precision())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::GIFTCARD): ?>
                                <span><?php echo e(get_amount(@$item->charge->total_charge,@$item->details->charge_info->wallet_currency,get_wallet_precision())); ?></span>
                            <?php endif; ?>
                        </div>
                    </div>
                    <?php if(@$item->type != payment_gateway_const()::BILLPAY): ?>
                    <?php if(@$item->type != payment_gateway_const()::MOBILETOPUP): ?>
                    <?php if(@$item->type != payment_gateway_const()::GIFTCARD): ?>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="lab la-get-pocket"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                                        <span><?php echo e(__("Current Balance")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>
                                        <span><?php echo e(__("Will Get")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::BILLPAY): ?>
                                        <span><?php echo e(__("Payable Amount")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::MOBILETOPUP): ?>
                                        <span><?php echo e(__("Payable Amount")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::TYPEMONEYEXCHANGE): ?>
                                        <span><?php echo e(__("total Payable")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                                        <span><?php echo e(__("Total Received")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                                        <span><?php echo e(__("Card Amount")); ?></span>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                                <span class="text-success fw-bold"><?php echo e(get_amount(@$item->available_balance,get_default_currency_code(),get_wallet_precision())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>

                                <span><?php echo e(isCrypto(@$item->details->withdraw_data->conversion_amount,$item->currency->currency_code??get_default_currency_code(),$item->currency->gateway->crypto)); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::BILLPAY): ?>
                                <span class="fw-bold"><?php echo e(get_amount(@$item->payable,get_default_currency_code())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::MOBILETOPUP): ?>
                                <span class="fw-bold"><?php echo e(get_amount(@$item->payable,get_default_currency_code())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                            <span class="fw-bold"> <?php echo e(get_amount(@$item->details->card_info->amount??@$item->details->card_info->balance,get_default_currency_code(),get_wallet_precision())); ?></span>

                            <?php elseif(@$item->type == payment_gateway_const()::TYPEMONEYEXCHANGE): ?>
                                <span><?php echo e(get_amount(@$item->payable,@$item->user_wallet->currency->code)); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                                <span><?php echo e(get_amount(@$item->payable,@$item->user_wallet->currency->code,get_wallet_precision())); ?></span>
                            <?php endif; ?>
                        </div>
                    </div>
                    <?php endif; ?>
                    <?php endif; ?>
                    <?php endif; ?>
                    <?php if(@$item->type != payment_gateway_const()::TYPEADDMONEY): ?>
                    <?php if(@$item->type != payment_gateway_const()::GIFTCARD): ?>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-receipt"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                                        <span><?php echo e(__("Total Amount")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>
                                        <span><?php echo e(__("Current Balance")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::BILLPAY): ?>
                                        <span><?php echo e(__("Current Balance")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::MOBILETOPUP): ?>
                                        <span><?php echo e(__("Current Balance")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                                        <span><?php echo e(__("Card Masked")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::TYPEMONEYEXCHANGE): ?>
                                        <span><?php echo e(__("Exchange Amount")); ?></span>
                                    <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                                        <span><?php echo e(__("Remark")); ?></span>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>

                        <div class="preview-list-right">
                            <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                                <span class="text--warning"><?php echo e(get_amount(@$item->payable,@$item->currency->currency_code)); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::WITHDRAWMONEY): ?>
                                <span class="text--success fw-bold"><?php echo e(get_amount(@$item->available_balance,get_default_currency_code(),get_wallet_precision())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::BILLPAY): ?>
                                <span class="text--danger"><?php echo e(get_amount(@$item->available_balance,get_default_currency_code())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::MOBILETOPUP): ?>
                                <span class="text--danger"><?php echo e(get_amount(@$item->available_balance,get_default_currency_code())); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                            <?php
                                $card_number = $item->details->card_info->card_pan?? $item->details->card_info->maskedPan ?? $item->details->card_info->card_number ?? $item->details->card_info->masked_pan ??  "";
                            ?>
                            <?php if($card_number): ?>
                                <?php
                                    $card_pan = str_split($card_number, 4);
                                ?>
                                <?php $__currentLoopData = $card_pan; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <span class="text--base fw-bold"><?php echo e($value); ?></span>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            <?php else: ?>
                                <span class="text--base fw-bold">----</span>
                                <span class="text--base fw-bold">----</span>
                                <span class="text--base fw-bold">----</span>
                                <span class="text--base fw-bold">----</span>
                            <?php endif; ?>

                            <?php elseif(@$item->type == payment_gateway_const()::TYPEMONEYEXCHANGE): ?>
                                <span class="text--warning"><?php echo e(get_amount(@$item->details->exchange_amount,@$item->details->exchange_currency)); ?></span>
                            <?php elseif(@$item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE): ?>
                                <span class="text--warning"><?php echo e(@$item->remark); ?></span>
                            <?php endif; ?>
                        </div>
                    </div>
                    <?php endif; ?>
                <?php endif; ?>
                <?php endif; ?>
                <?php if(@$item->type == payment_gateway_const()::VIRTUALCARD): ?>
                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="las la-smoking"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Current Balance")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span class="fw-bold"><?php echo e(get_amount(@$item->available_balance,get_default_currency_code(),get_wallet_precision())); ?></span>
                    </div>
                </div>
                <?php endif; ?>


                <?php if(@$item->type == payment_gateway_const()::TYPEADDMONEY): ?>
                    <?php
                        $is_tatum_status = false;
                        if ($item->gateway_currency && $item->gateway_currency->gateway) {
                            $is_tatum_status = $item->gateway_currency->gateway->isTatum($item->gateway_currency->gateway);
                        }
                    ?>

                    <?php if($is_tatum_status && $item->status == payment_gateway_const()::STATUSWAITING): ?>
                    <div class="col-12">
                        <form action="<?php echo e(setRoute('user.add.money.payment.crypto.confirm', $item->trx_id)); ?>" method="POST">
                            <?php echo csrf_field(); ?>
                            <?php
                                $input_fields = $item->details->payment_info->requirements ?? [];
                            ?>

                            <?php $__currentLoopData = $input_fields; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $input): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <div class="p-3">
                                    <h6 class="mb-2"><?php echo e($input->label); ?></h6>
                                    <input type="text" class="form-control form--control ref-input text-light copiable" name="<?php echo e($input->name); ?>" placeholder="<?php echo e($input->placeholder ?? ""); ?>" required>
                                </div>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                            <div class="text-end">
                                <button type="submit" class="btn--base my-2"><?php echo e(__("Process")); ?></button>
                            </div>

                        </form>
                    </div>
                    <?php endif; ?>
                <?php endif; ?>
                
                <?php if($item->type == payment_gateway_const()::GIFTCARD): ?>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-receipt"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Card Name")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="fw-bold"><?php echo e($item->details->card_info->card_name); ?></span>
                        </div>
                    </div>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-receipt"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("receiver Email")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="fw-bold"><?php echo e($item->details->card_info->recipient_email); ?></span>
                        </div>
                    </div>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-receipt"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Receiver Phone")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="fw-bold"><?php echo e($item->details->card_info->recipient_phone); ?></span>
                        </div>
                    </div>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-wallet"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Card Unit Price")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="fw-bold"><?php echo e(get_amount($item->details->card_info->card_amount,$item->details->card_info->card_currency,get_wallet_precision())); ?></span>
                        </div>
                    </div>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-wallet"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Card Quantity")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="fw-bold"><?php echo e($item->details->card_info->qty); ?></span>
                        </div>
                    </div>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-wallet"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Card Total Price")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="fw-bold"><?php echo e(get_amount($item->details->card_info->card_total_amount,$item->details->card_info->card_currency,get_wallet_precision())); ?></span>
                        </div>
                    </div>
                    <div class="preview-list-item">
                        <div class="preview-list-left">
                            <div class="preview-list-user-wrapper">
                                <div class="preview-list-user-icon">
                                    <i class="las la-smoking"></i>
                                </div>
                                <div class="preview-list-user-content">
                                    <span><?php echo e(__("Current Balance")); ?></span>
                                </div>
                            </div>
                        </div>
                        <div class="preview-list-right">
                            <span class="fw-bold"><?php echo e(get_amount($item->available_balance,@$item->details->charge_info->wallet_currency,get_wallet_precision())); ?></span>
                        </div>
                    </div>
                <?php endif; ?>
                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="las la-clock"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Time & Date")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span><?php echo e(dateFormat('d-m-y h:i:s A', @$item->created_at)); ?></span>
                    </div>
                </div>
                <?php if( @$item->status == 4 &&  @$item->reject_reason != null): ?>
                <div class="preview-list-item">
                    <div class="preview-list-left">
                        <div class="preview-list-user-wrapper">
                            <div class="preview-list-user-icon">
                                <i class="las la-smoking"></i>
                            </div>
                            <div class="preview-list-user-content">
                                <span><?php echo e(__("Rejection Reason")); ?></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-list-right">
                        <span class="text-danger"><?php echo e(@$item->reject_reason); ?></span>
                    </div>
                </div>
                <?php endif; ?>



            </div>
        </div>
    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
        <div class="alert alert-primary text-center">
            <?php echo e(__("No Record Found!")); ?>

        </div>
    <?php endif; ?>

    <?php echo e(get_paginate($transactions)); ?>



<?php endif; ?>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/components/transaction-log.blade.php ENDPATH**/ ?>