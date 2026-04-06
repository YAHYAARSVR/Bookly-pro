<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    use HasFactory;

    protected $fillable = [
        'business_id',
        'service_id',
        'staff_member_id',
        'customer_name',
        'customer_email',
        'customer_phone',
        'booking_date',
        'start_time',
        'end_time',
        'total_amount',
        'payment_status',
        'notes',
        'user_id',   // صاحب الحجز (لو مسجّل في التطبيق)
    ];

    protected $dates = [
        'booking_date',
        'start_time',
        'end_time',
    ];

    public function business()
    {
        return $this->belongsTo(Business::class);
    }

    public function service()
    {
        return $this->belongsTo(Service::class);
    }

    public function staffMember()
    {
        return $this->belongsTo(StaffMember::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function payment()
    {
        return $this->hasOne(Payment::class);
    }
}
