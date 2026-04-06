<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Business extends Model
{
    use HasFactory;

    protected $fillable = [
        'owner_id',
        'name',
        'description',
        'address',
        'city',
        'phone',
        'email',
        'website',
        'is_active',
    ];

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function services()
    {
        return $this->hasMany(Service::class);
    }

    public function staffMembers()
    {
        return $this->hasMany(StaffMember::class);
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }
}
