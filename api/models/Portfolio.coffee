module.exports =
  tablesName: 'portfolio'
  schema: true
  attributes:
    symbol:
      type: 'string'
      required: true
    name:
      type: 'string'
    type:
      type: 'string'
    date:
      type: 'date'
    quantity:
      type: 'float'
    price:
      type: 'float'
    notes:
      type: 'string'
    createdBy:
      model: 'user'
      required: true
