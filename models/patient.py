from odoo import api, fields, models
from odoo.exceptions import ValidationError

class HospitalPatient(models.Model):
    _name = 'hospital.patient'
    _description = 'Hospital Patient'
    _rec_name = 'reference'
    _order = 'create_date DESC'

    reference = fields.Char(string='Reference', required=True, copy=False, readonly=True, default='New')
    name = fields.Char(string='Full Name', required=True, tracking=True)
    age = fields.Integer(string='Age', tracking=True)
    gender = fields.Selection([
        ('male', 'Male'),
        ('female', 'Female'),
        ('other', 'Other'),
    ], required=True, default='male', tracking=True)
    notes = fields.Text(string='Notes')
    active = fields.Boolean(default=True)

    @api.model
    def create(self, vals):
        if vals.get('reference', 'New') == 'New':
            vals['reference'] = self.env['ir.sequence'].next_by_code('hospital.patient.sequence') or 'New'
        return super(HospitalPatient, self).create(vals)

    @api.constrains('age')
    def _check_age(self):
        for record in self:
            if record.age <= 0:
                raise ValidationError("Age must be a positive number.")

    def name_get(self):
        return [(record.id, f"{record.reference} - {record.name}") for record in self]

    def toggle_active(self):
        for record in self:
            record.active = not record.active