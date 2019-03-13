<template>
  <v-layout row xs12>
    <v-flex md3>
      <slot name='col1' />
    </v-flex>
    <v-flex md3>
      <slot name='col2' />
    </v-flex>
    <v-flex md3>
      <slot name='col3' />
    </v-flex>
    <v-flex md3>
      <slot name='col4' />
    </v-flex>
  </v-layout>
</template>
