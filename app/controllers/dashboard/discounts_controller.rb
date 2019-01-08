class Dashboard::DiscountsController < Dashboard::BaseController
    
    def index
        @discounts = current_user.discounts_by_type(current_user.discount_type)
    end

    def new
        @discount = Discount.new
        @form_path = [:dashboard, @discount]
        params[:discount] ? set_discount_type_session(params[:discount]) : nil
        if current_user.discount_type == 2 && session[:discount_type] == nil
            redirect_to dashboard_set_type_path
        elsif discount_type(0)
            current_user.update(discount_type: 0)
            render partial: 'dashboard/discounts/percent_discount_form', layout: "application"
        elsif discount_type(1)
            current_user.update(discount_type: 1)
            render partial: 'dashboard/discounts/dollar_discount_form', layout: "application"
        end 
    end 

    def create
        if quantity_discount
            new_discount = Discount.create(discount_params)
            new_discount.update(kind: 0)
            redirect_to dashboard_discounts_path
        elsif dollar_discount
            new_discount = Discount.create(discount_params)
            new_discount.update(kind: 1)
            redirect_to dashboard_discounts_path
        end 
    end

    def set_type
    end 

    def toggle_discount
        chosen_discount = current_user.discount_type 
        chosen_discount == 0 ? chosen_discount = 1 : chosen_discount = 0 
        current_user.update(discount_type: chosen_discount)
        session[:discount_type] = chosen_discount
        redirect_to dashboard_discounts_path
    end

    def edit
        @discount = Discount.find(params[:id])
        @form_path = [:dashboard, @discount]
        if discount_type(0)
            autofill_min_max 
            render partial: 'dashboard/discounts/percent_discount_form', layout: "application"
        elsif discount_type(1)
            render partial: 'dashboard/discounts/dollar_discount_form', layout: "application"
        end
    end 

    def update
        @discount = Discount.find(params[:id]) 
        @discount.update(discount_params)
        # @updated_discount.kind = current_user.discount_type
        if @discount.save
            redirect_to dashboard_discounts_path
        else
            flash[:error] = @updated_discount.errors.full_messages
            edit
        end
    end 

    def destroy
        @discount = Discount.find(params[:id])
        @discount.destroy
        redirect_to dashboard_discounts_path
    end 

    private 

    def discount_params
        if quantity_discount
            discount = params.require(:discount).permit(:amount_off, :max_quantity, :min_quantity)
            discount[:quantity] = discount[:min_quantity]...discount[:max_quantity]
            discount[:user] = current_user 
            discount.except(:min_quantity, :max_quantity)
        elsif dollar_discount
            discount = params.require(:discount).permit(:amount_off, :item_total)
            discount[:user] = current_user
            discount
        end
    end 

    def set_discount_type_session(numba)
        session[:discount_type] = numba.to_i 
    end 

    def quantity_discount
        params[:discount][:min_quantity]
    end
    
    def dollar_discount
        params[:discount][:item_total]
    end 

    def discount_type(type)
        session[:discount_type] == type || current_user.discount_type == type
    end 

    def autofill_min_max
        min = @discount.quantity.to_a.first
        max = @discount.quantity.to_a.last + 1
        params[:autofill] = 123
        params[:discount] = {min_quantity: min, max_quantity: max}
    end
end 