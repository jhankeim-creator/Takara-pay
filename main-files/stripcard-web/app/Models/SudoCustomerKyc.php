<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SudoCustomerKyc extends Model
{
    use HasFactory;

    protected $appends = ['frontIdImage','backIdImage','addressVerificationImage'];
    protected $guarded = ['id'];

    protected $casts = [
        'user_id'              => 'integer',
        'id_image_front'       => 'string',
        'id_image_back'        => 'string',
        'address_verification' => 'string',
    ];

    public function user() {
        return $this->belongsTo(User::class);
    }

    public function getFrontIdImageAttribute() {
        $image = $this->attributes['id_image_front']??$this->id_image_front??null;
        if($image == null) {
            return files_asset_path('profile-default');
        }else if(filter_var($image, FILTER_VALIDATE_URL)) {
            return $image;
        }else {
            return files_asset_path("sudo-kyc-images") . "/" . $image;
        }
    }
    public function getBackIdImageAttribute() {
        $image = $this->attributes['id_image_back'] ?? $this->id_image_back ?? null;
        if($image == null) {
            return files_asset_path('profile-default');
        }else if(filter_var($image, FILTER_VALIDATE_URL)) {
            return $image;
        }else {
            return files_asset_path("sudo-kyc-images") . "/" . $image;
        }
    }
    public function getAddressVerificationImageAttribute() {
        $image = $this->attributes['address_verification'] ?? $this->address_verification ?? null;
        if($image == null) {
            return files_asset_path('profile-default');
        }else if(filter_var($image, FILTER_VALIDATE_URL)) {
            return $image;
        }else {
            return files_asset_path("sudo-kyc-images") . "/" . $image;
        }
    }
}
