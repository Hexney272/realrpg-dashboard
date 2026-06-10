<template>
  <div class="ppshop-panel">
    <div class="shop-header">
      <div class="menu-tabs">
        <button v-for="(m,i) in shop" :key="i" :class="['tab-btn',{active:tab===i}]" @click="tab=i">{{ m.name }}</button>
      </div>
      <div class="balance-box">Egyenleg: <strong>{{ fmt(balance) }} RC</strong></div>
    </div>
    <div class="shop-grid" v-if="items.length">
      <div v-for="(item,i) in items" :key="i" class="shop-card">
        <div class="item-icon">{{ item.item==='money'?'💵':'🔫' }}</div>
        <div class="item-name">{{ item.item==='money' ? fmt(item.amount||0)+' $' : item.item }}</div>
        <div class="item-price-tag"><span class="price-num">{{ fmt(item.price) }}</span> RC</div>
        <button :class="['btn',item.price<=balance?'btn-blue':'btn-disabled btn-red']" :disabled="item.price>balance" @click="openBuyModal(i)">
          {{ item.price<=balance?'VÁSÁRLÁS':'Nincs elég RC' }}
        </button>
      </div>
    </div>
    <div v-else class="empty-state">Nincs elem ebben a kategóriában.</div>

    <!-- Buy confirmation modal -->
    <div v-if="showBuyModal" class="modal-overlay" @click.self="showBuyModal=false">
      <div class="modal card">
        <h3 class="card-title">Vásárlás megerősítése</h3>
        <p class="modal-item-name">{{ buyingItem?.item==='money' ? fmt(buyingItem?.amount||0)+' $' : buyingItem?.item }}</p>
        <div class="amount-row">
          <label class="amount-label">Mennyiség:</label>
          <input v-model.number="buyAmount" class="input-field amount-input" type="number" min="1" max="99" />
        </div>
        <p class="modal-cost">
          Fizetendő: <strong class="cost-val">{{ fmt((buyingItem?.price||0) * (buyAmount||1)) }} RC</strong>
        </p>
        <p v-if="(buyingItem?.price||0)*(buyAmount||1) > balance" class="modal-error">Nincs elég RealCoinod!</p>
        <div class="btn-row">
          <button class="btn btn-green" :disabled="(buyingItem?.price||0)*(buyAmount||1) > balance" @click="confirmBuy">Vásárlás</button>
          <button class="btn btn-red" @click="showBuyModal=false">Mégsem</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
const props = defineProps({shop:{type:Array,default:()=>[]},balance:{type:Number,default:0}})
const tab = ref(0)
const showBuyModal = ref(false)
const buyingIndex = ref(0)
const buyAmount = ref(1)
const items = computed(()=>(props.shop[tab.value]?.items)||[])
const buyingItem = computed(()=>items.value[buyingIndex.value]||null)

function fmt(n){return(n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g,'.')}
function post(e,d){fetch(`https://${window.GetParentResourceName?window.GetParentResourceName():'realrpg-dashboard'}/${e}`,{method:'POST',body:JSON.stringify(d)})}

function openBuyModal(i){
  buyingIndex.value = i
  buyAmount.value = 1
  showBuyModal.value = true
}

function confirmBuy(){
  if(!buyingItem.value) return
  if((buyingItem.value.price||0)*(buyAmount.value||1) > props.balance) return
  post('buyPremiumItem',{menuIndex:tab.value+1, itemIndex:buyingIndex.value+1, amount:buyAmount.value||1})
  showBuyModal.value = false
}
</script>
<style scoped>
.shop-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;flex-wrap:wrap;gap:8px}
.menu-tabs{display:flex;gap:4px;flex-wrap:wrap}
.tab-btn{padding:6px 14px;border:1px solid var(--sightgrey4);background:var(--sightgrey2);color:var(--text-secondary);border-radius:3px;font-size:12px;font-weight:700;cursor:pointer;transition:all .2s;text-transform:uppercase}
.tab-btn:hover{border-color:var(--sightblue);color:var(--sightblue)}
.tab-btn.active{background:var(--sightblue);color:#fff;border-color:var(--sightblue)}
.balance-box{font-size:13px;color:var(--text-secondary)}
.balance-box strong{color:var(--sightblue)}
.shop-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:10px}
.shop-card{background:var(--sightgrey2);border:1px solid var(--sightgrey3);border-radius:4px;padding:14px;text-align:center;display:flex;flex-direction:column;align-items:center;gap:6px;transition:border-color .2s}
.shop-card:hover{border-color:var(--sightblue)}
.item-icon{font-size:28px;margin-bottom:4px}
.item-name{font-size:12px;font-weight:700;text-transform:uppercase;color:var(--text-primary)}
.item-price-tag{background:var(--sightgreen);color:#000;padding:2px 8px;border-radius:2px;font-size:12px;font-weight:700}
.price-num{font-size:13px}
.modal-item-name{text-align:center;font-size:16px;font-weight:700;text-transform:uppercase;margin-bottom:12px;color:var(--sightblue)}
.amount-row{display:flex;align-items:center;gap:10px;margin-bottom:10px}
.amount-label{color:var(--text-secondary);font-size:13px;white-space:nowrap}
.amount-input{width:80px}
.modal-cost{font-size:13px;color:var(--text-secondary);margin-bottom:4px}
.cost-val{color:var(--sightblue)}
.modal-error{color:var(--sightred);font-size:12px;font-weight:700;margin-bottom:8px}
.btn-row{display:flex;gap:8px;margin-top:12px}
</style>
