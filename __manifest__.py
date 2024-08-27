{
    'name': 'Hospital Patient Management',
    'version': '15.0.1.0.0',
    'category': 'Healthcare',
    'summary': 'Efficient hospital patient management system',
    'description': """
        Advanced hospital patient management module for Odoo 15.
        Features:
        - Create and manage patient records
        - Auto-generated unique patient references
        - User-friendly interface for healthcare professionals
    """,
    'author': 'Your Company',
    'website': 'https://www.yourcompany.com',
    'depends': ['base'],
    'data': [
        'security/ir.model.access.csv',
        'views/patient_views.xml',
        'data/patient_sequence.xml',
    ],
    'demo': [],
    'installable': True,
    'application': True,
    'auto_install': False,
    'license': 'LGPL-3',
}