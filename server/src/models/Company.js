const mongoose = require('mongoose');

const companySchema = mongoose.Schema({
  name: { type: String, required: true },
  phone: { type: String, required: true, unique: true },
  address: { type: String, required: true },
  owner: {
    name: { type: String, required: true },
    phone: { type: String, required: true }, // Owner phone might not be unique? User requested "phone number email as uniq". 
    // Assuming company phone and owner email should be unique. 
    whatsapp: { type: String },
    email: { type: String, required: true, unique: true },
  },
  isActive: { type: Boolean, default: true },
}, { timestamps: true });

module.exports = mongoose.model('Company', companySchema);
