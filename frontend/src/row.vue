<template>
  <v-layout row xs12>
    <v-flex md3>
      <slot name='header' />
    </v-flex>
    <v-flex md6>
      <slot name='content' />
    </v-flex>
    <v-flex md3>
      <slot name='footer' />
    </v-flex>
  </v-layout>
</template>
