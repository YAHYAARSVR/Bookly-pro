<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    // ─── Relations ──────────────────────────────────────────────
    public function businesses()
    {
        return $this->hasMany(Business::class, 'owner_id');
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    // ─── Fillable ───────────────────────────────────────────────
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    // ─── Hidden ─────────────────────────────────────────────────
    protected $hidden = [
        'password',
        'remember_token',
    ];

    // ─── Casts ──────────────────────────────────────────────────
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}
