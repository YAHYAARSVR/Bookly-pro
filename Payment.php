<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    use HasFactory;

    protected $fillable = [
        'booking_id',
        'user_id',
        'amount',
        'currency',
        'provider',          // stripe, paypal, etc.
        'provider_payment_id',
        'status',            // pending, paid, failed, refunded
        'paid_at',
    ];

    protected $dates = [
        'paid_at',
    ];

    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
