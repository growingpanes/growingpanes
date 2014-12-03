Panesfe::Admin.controllers :presentations do
  get :index do
    @title = "Presentations"
    @presentations = Presentation.all
    render 'presentations/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'presentation')
    @presentation = Presentation.new
    render 'presentations/new'
  end

  post :create do
    @presentation = Presentation.new(params[:presentation])
    @presentation.user = current_account
    if @presentation.save
      @title = pat(:create_title, :model => "presentation #{@presentation.id}")
      flash[:success] = pat(:create_success, :model => 'Presentation')
      params[:save_and_continue] ? redirect(url(:presentations, :index)) : redirect(url(:presentations, :edit, :id => @presentation.id))
    else
      @title = pat(:create_title, :model => 'presentation')
      flash.now[:error] = pat(:create_error, :model => 'presentation')
      render 'presentations/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "presentation #{params[:id]}")
    @presentation = Presentation.get(params[:id])
    if @presentation
      render 'presentations/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'presentation', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "presentation #{params[:id]}")
    @presentation = Presentation.get(params[:id])
    if @presentation
      if @presentation.update(params[:presentation])
        flash[:success] = pat(:update_success, :model => 'Presentation', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:presentations, :index)) :
          redirect(url(:presentations, :edit, :id => @presentation.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'presentation')
        render 'presentations/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'presentation', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Presentations"
    presentation = Presentation.get(params[:id])
    if presentation
      if presentation.destroy
        flash[:success] = pat(:delete_success, :model => 'Presentation', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'presentation')
      end
      redirect url(:presentations, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'presentation', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Presentations"
    unless params[:presentation_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'presentation')
      redirect(url(:presentations, :index))
    end
    ids = params[:presentation_ids].split(',').map(&:strip)
    presentations = Presentation.all(:id => ids)
    
    if presentations.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Presentations', :ids => "#{ids.to_sentence}")
    end
    redirect url(:presentations, :index)
  end
end
